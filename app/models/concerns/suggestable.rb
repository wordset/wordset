module Suggestable
  extend ActiveSupport::Concern

  included do |base|
    base.has_many :suggestions, as: :target
  end

  class_methods do
    # IMPLEMENT IN CLASS
    def suggestable_fields
      %w()
    end

    # IMPLEMENT IN CLASS
    def suggestable_children
      %w()
    end

    # We use this to test if a class is suggestable
    def suggestable?
      true
    end

    # To create a proper suggestion
    def suggest(user, delta, target = nil)
      if self != Word
        throw "Requires a valid target" if target.nil?
      end
      Suggestion.new(action: "create", create_class_name: self.to_s, delta: delta, user: user, target: target)
    end

    def new_from_suggestion(suggestion)
      if suggestion.create_class == Word
        Word.new.apply_suggestion(suggestion["delta"])
      else
        suggestion.target.new_child_from_suggestion(suggestion)
      end
    end

    def validate_suggestion(suggestion, errors)
      merge_errors(errors, new_from_suggestion(suggestion))
    end

    def merge_errors(error_obj, model)
      store = {}
      model.errors.each do |name, msg|
        store[name] ||= []
        store[name] << msg
      end
      model.valid?
      store.each do |name, list|
        list.each do |msg|
          error_obj.add name, msg
        end
      end
      model.errors.each do |name, msg|
        error_obj.add name, msg
      end
      model
    end
  end

  def suggest(action, user, delta = {})
    self.suggestions.build(delta: delta, word: word, user: user, action: action)
  end

  def suggest_change(user, delta = {})
    suggest("change", user, delta)
  end

  def apply_suggestion(delta)
    delta.each do |field, value|
      if self.class.suggestable_children.include?(field.to_s)
        value.each do |child_delta|
          child = field.to_s.classify.constantize.new(self.class.to_s.underscore => self)
          child.apply_suggestion(child_delta)
          self.class.merge_errors(self.errors, child)
          self.send(field) << child
        end
      else
        if !self.class.suggestable_fields.include?(field.to_s)
          errors.add field, "is not suggestable"
        end
        self[field] = value
      end
    end
    self
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
    # to actually save the delta (like, when we make a new)
    # suggestion. We dup it FIRST.
    model = self.dup
    # And then we only apply the suggestion to the new dup'd model
    model.apply_suggestion(suggestion["delta"])
    # this will grab all of the applied suggestable validations from the apply_suggestion method
    self.class.merge_errors(errors, model)
  end

  # This is called when we need a new child of me from a create suggestion
  def new_child_from_suggestion(suggestion)
    model = suggestion.create_class.new
    model.apply_suggestion suggestion["delta"]
    model[self.class.to_s.underscore] = self
    model
  end

end
