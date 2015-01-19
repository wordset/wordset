module Suggestable
  extend ActiveSupport::Concern

  included do |base|
    base.has_many :suggestions, as: :target
  end

  class_methods do
    def suggestable_fields
      %()
    end

    def suggestable_children
      %()
    end
  end

  def suggest(action, user, data = {})
    self.suggestions.build(data: data, word: word, user: user, action: action)
  end

  Suggestion.actions.each do |action|
    define_method("suggest_#{action}") do |*args|
      suggest(action, *args)
    end
  end

  def validate_suggestion(suggestion, errors)
    model = self.dup
    suggestion["data"].each do |field, value|
      if !self.class.suggestable_fields.include?(field.to_s)
        errors.add field, "is not suggestable"
      end
      model[field] = value
    end
    unless model.valid?
      model.errors.each do |name, msg|
        errors.add name, msg
      end
    end
  end

end
