module TrustLevel
  extend ActiveSupport::Concern

  STARTING_TRUST = 25
  DEMOTE_AFTER = 20

  LEVELS = {
    banned: {
      name: "Banned",
      vote_value: 0,
      min_trust: -10_000,
    },
    fresh_face: {
      name: "Fresh Face",
      vote_value: 1,
      min_trust: -200,
      initial: true
    },
    junior_contributor: {
      name: "Junior Contributor",
      vote_value: 5,
      min_trust: 50
    },
    contributor: {
      name: "Contributor",
      vote_value: 10,
      min_trust: 150
    },
    senior_contributor: {
      name: "Senior Contributor",
      vote_value: 15,
      min_trust: 500
    },
    junior_member: {
      name: "Junior Member",
      vote_value: 20,
      min_trust: 1_000,
    },
    member: {
      name: "Member",
      vote_value: 25,
      min_trust: 5_000,
    },
    senior_member: {
      name: "Senior Member",
      vote_value: 30,
      min_trust: 10_000,
    },
    junior_editor: {
      name: "Junior Editor",
      vote_value: 40,
      min_trust: 25_000
    },
    editor: {
      name: "Editor",
      vote_value: 45,
      min_trust: 50_000
    },
    senior_editor: {
      name: "Senior Editor",
      vote_value: 55,
      min_trust: 100_000
    },
    staff_editor: {
      name: "Staff Editor",
      vote_value: 60,
      min_trust: 1_000_000
    },
    admin: {
      name: "Admin",
      vote_value: 50,
      min_trust: nil
    }
  }

  included do |base|
    base.include AASM
    base.field :trust_level, type: String
    base.field :trust_points, type: Integer
    base.aasm :column => :trust_level do
      LEVELS.each do |level_name, level|
        state(level_name, initial: level[:initial])
      end

      event :promote, after: :notify_promotion do
        last_level = nil
        LEVELS.keys.each do |name|
          if last_level && name != :admin
            transitions from: last_level, to: name
          end
          last_level = name
        end
      end

      event :demote, after: :notify_demotion do
        last_level = nil
        LEVELS.keys.each do |name|
          if last_level && name != :admin
            transitions from: name, to: last_level
          end
          last_level = name
        end
      end
    end
    base.before_save :calculate_trust_points
    base.after_save :check_trust_level
  end

  def notify_promotion
    UserPromotionActivity.create(new_level: self.trust_level_name, user: self)
  end

  def notify_demotion
    # TODO: Find a classy way to handle this.
  end

  def trust_level_data
    LEVELS[trust_level.to_sym]
  end

  def trust_level_name
    trust_level_data[:name]
  end

  def calculate_trust_points
    trust = STARTING_TRUST
    trust += self.votes.sum(:trust_points)
    trust += self.proposals.accepted.count *  10
    trust += self.proposals.rejected.count * -20
    trust += self.proposals.flagged.count  * -75
    self.trust_points = trust
  end

  def calculate_trust_level
    return :admin if admin?
    level = nil
    LEVELS.select do |name, data|
      if data[:min_trust] && data[:min_trust] > self.trust_points
        return level || name
      else
        level = name
      end
    end
  end

  def check_trust_level
    return if admin?
    current_level = self.trust_level.to_sym || :fresh_face
    level = calculate_trust_level
    min_trust = LEVELS[level][:min_trust]
    difference = compare_levels(level, current_level)
    if difference > 0
      #puts "Promote #{self.id}"
      self.promote!
    elsif difference < 0 && (min_trust - self.trust_points) > DEMOTE_AFTER
      #puts "Demote #{self.id}"
      self.demote!
    end
  end

  def compare_levels(new_level, old_level)
    LEVELS[new_level][:min_trust] - LEVELS[old_level][:min_trust]
  end

  def legacy_level
    if admin?
      return :admin
    elsif self.points > 4000
      return :senior_editor
    elsif self.points > 200
      return :editor
    elsif self.points > 100
      return :junior_editor
    elsif self.points > 10
      return :contributor
    else
      return :user
    end
  end

  def vote_value
    if trust_level_data.nil?
      check_trust_level
    end
    trust_level_data[:vote_value]
  end

end
