module SoftRemove
  extend ActiveSupport::Concern
  include ActiveSupport::Callbacks

  included do |base|
    base.field :removed_at, type: Time, default: nil
    base.default_scope(Proc.new() { where(removed_at: nil) })
    base.index({removed_at: 1})
    base.include ActiveSupport::Callbacks
    base.define_callbacks :remove
  end

  def remove!
    run_callbacks :remove do
      self.removed_at = Time.now
      self.save!
    end
  end
end
