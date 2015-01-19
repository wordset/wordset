module Suggestable
  extend ActiveSupport::Concern

  included do |base|
    base.has_many :suggestions, as: :target
  end

  class_methods do
    # IMPLEMENT IN CLASS
    def suggestable_fields
      %()
    end

    # IMPLEMENT IN CLASS
    def suggestable_children
      %()
    end

    # We use this to test if a class is suggestable
    def suggestable?
      true
    end

    # To create a proper suggestion
    def suggest(user, data, target = nil)
      if self.class != Word
        throw "Requires a valid target" if target.nil?
      end
      Suggestion.new(action: "create", create_class_name: self.to_s, data: data, user: user, target: target)
    end

    def new_from_suggestion(suggestion)
      if suggestion.create_class == Word
        Word.new(suggestion.data)
      else
        suggestion.target.new_child_from_suggestion(suggestion)
      end
    end

    def validate_suggestion(suggestion, errors)
      model = new_from_suggestion(suggestion)
      model.errors.each do |name, msg|
        errors.add name, msg
      end
      model.valid?
      model.errors.each do |name, msg|
        errors.add name, msg
      end
    end
  end

  def suggest(action, user, data = {})
    self.suggestions.build(data: data, word: word, user: user, action: action)
  end

  def suggest_change(user, data = {})
    suggest("change", user, data)
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
    if suggestion.action == "change"
      validate_change_suggestion(suggestion, errors)
    elsif suggestion.action == "destroy"
      true
    end
  end

  def validate_change_suggestion(suggestion, errors)
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

  # This is called when we need a new child of me from a create suggestion
  def new_child_from_suggestion(suggestion)
    model = suggestion.create_class.new
    model.apply_suggestion suggestion
    model[self.class.to_s.underscore] = self
    model
  end

end
