module PosLike
  extend ActiveSupport::Concern

  included do |base|
    base.field :pos, type: String
    base.validates :pos,
                   :inclusion => {in: Proc.new { Entry.pos } }
  end
end
