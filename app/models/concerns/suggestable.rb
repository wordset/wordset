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

  def apply_suggestion(suggestion)
    suggestion["data"].each do |field, value|
      if !self.class.suggestable_fields.include?(field.to_s)
        errors.add field, "is not suggestable"
      end
      self[field] = value
    end
  end

  def validate_suggestion(suggestion, errors)
    # Since we are changing the model, and we don't want
    # to actually save the data (like, when we make a new)
    # suggestion. We dup it FIRST.
    model = self.dup
    # And then we only apply the suggestion to the new dup'd model
    model.apply_suggestion(suggestion)
    # this will grab all of the applied suggestable validations from the apply_suggestion method
    if model.errors.any?
      model.errors.each do |name, msg|
        errors.add name, msg
      end
    end
    # We want to re-run any validations at this point
    unless model.valid?
      model.errors.each do |name, msg|
        errors.add name, msg
      end
    end
    # Return the dup'd model, in case someone does want to do something
    # with it after
    model
  end

end
