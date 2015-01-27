module Editable
  extend ActiveSupport::Concern

  included do |base|
    unless base.is_a? Word
      base.has_many :proposals, as: :target, inverse_of: :target
    end
  end

  class_methods do
    # IMPLEMENT IN CLASS
    def editable_fields
      %w()
    end

    # IMPLEMENT IN CLASS
    def editable_children
      %w()
    end

    # We use this to test if a class is editable
    def editable?
      true
    end

    # To create a proper proposal
    def propose(user, delta, target = nil)
      if self != Word
        throw "Requires a valid target" if target.nil?
      end
      Proposal.new(action: "create", create_class_name: self.to_s, delta: delta, user: user, target: target)
    end

    def new_from_proposal(proposal)
      if proposal.create_class == Word
        Word.new.apply_proposal(proposal["delta"])
      else
        proposal.target.new_child_from_proposal(proposal)
      end
    end

    def validate_proposal(proposal, errors)
      merge_errors(errors, new_from_proposal(proposal))
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

  def propose(action, user, delta = {})
    self.proposals.build(delta: delta, word: word, user: user, action: action)
  end

  def propose_change(user, delta = {})
    propose("change", user, delta)
  end

  def apply_proposal(delta)
    delta.each do |field, value|
      if self.class.editable_children.include?(field.to_s)
        value.each do |child_delta|
          child = field.to_s.classify.constantize.new(self.class.to_s.underscore => self)
          child.apply_proposal(child_delta)
          self.class.merge_errors(self.errors, child)
          self.send(field) << child
        end
      else
        if !self.class.editable_fields.include?(field.to_s)
          errors.add field, "is not editable"
        end
        self[field] = value
      end
    end
    self
  end

  def validate_proposal(proposal, errors)
    if proposal.action == "change"
      validate_change_proposal(proposal, errors)
    elsif proposal.action == "destroy"
      true
    end
  end

  def deep_copy
    model = self.clone

    self.class.editable_children.each do |child_relation|
      self.send(child_relation).each do |child|
        model.send("#{child_relation}") << child.deep_copy
      end
    end
    model
  end

  def validate_change_proposal(proposal, errors)
    # Since we are changing the model, and we don't want
    # to actually save the delta (like, when we make a new)
    # proposal. We dup it FIRST.
    model = self.deep_copy
    # And then we only apply the proposal to the new dup'd model
    model.apply_proposal(proposal["delta"])
    # this will grab all of the applied editable validations from the apply_proposal method
    self.class.merge_errors(errors, model)
  end

  # This is called when we need a new child of me from a create proposal
  def new_child_from_proposal(proposal)
    model = proposal.create_class.new
    model.apply_proposal proposal["delta"]
    model[self.class.to_s.underscore] = self
    model
  end

end
