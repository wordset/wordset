module Labeled
  extend ActiveSupport::Concern

  included do |base|
    base.has_and_belongs_to_many :labels, inverse_of: nil
  end

  

end
