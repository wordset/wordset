module Badger
  extend ActiveSupport::Concern

  included do |base|

  end

  class_methods do
    def badge(name, &block)
      badges[name.to_sym] = Configuration.new(name, self, block)
    end

    def badges
      @@badges ||= {}
    end
  end

  class Configuration
    @@directory = {}
    def self.directory
      @@directory
    end

    def initialize(name, klass, block)
      @klass = klass
      @klass_table = @klass.to_s.underscore.pluralize
      @name = name

      @event_name = :after_create
      @base_levels = [1]

      @target_method = :user
      @target_block = Proc.new do |model|
        model.send(@target_method)
      end

      @value_block = Proc.new do |model|
        if model.user_id.nil?
          return -1
        end
        model.user.send(@klass_table).count
      end
      instance_eval(&block)
      if @display_name.nil?
        raise "Must configure display name"
      end

      config = self
      @klass.send(@event_name, Proc.new do
        config.badge_check(self)
      end)

      @@directory[klass] ||= []
      @@directory[klass] << self
    end

    def create_badge(model, level = 1)
      puts model.inspect
      puts level.inspect
      target = @target_block.call(model)
      badge = target.badges.where(name: @name, subject: @klass_table).first
      if badge
        if level > badge.level
          badge.update_attributes(level: level)
          badge.notify!
        end
      else
        puts "CERATING"
        badge = target.badges.create(name: @name, subject: @klass_table, level: level)
        badge.notify!
      end
    end

    def badge_check(model)
      if @condition_block
        if @condition_block.call(model)
          create_badge(model)
        end
      else
        value = @value_block.call(model)
        level = (@base_levels.index do |level_value|
          value >= level_value
        end) + 1
        create_badge(model, level)
      end
    end

    def target(name = nil, &block)
      if name
        @target_name = name
      end
      if block
        @target_block = block
      end
    end

    def display_name(name)
      @display_name = name
    end

    def on(event_name)
      @event_name = event_name
    end

    def value(&block)
      @value_block = block
    end

    def base_levels(levels)
      @base_levels = levels
    end
  end
end
