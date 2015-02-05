module MeaningLike
  extend ActiveSupport::Concern

  included do |base|
    base.field :def, type: String
    base.field :example, type: String

    base.validates :def,
                   :length => {minimum: 10},
                   :unless => :wordnet?
    base.validates :example,
                   :length => {minimum: 10},
                   :unless => :wordnet?
  end
end
