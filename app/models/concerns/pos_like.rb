module PosLike
  extend ActiveSupport::Concern

  included do |base|
    base.belongs_to :speech_part
    base.validates :speech_part,
                   :presence => true
  end

  class_methods do
    
  end

end
