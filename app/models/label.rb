class Label
  include Mongoid::Document

  belongs_to :lang
  belongs_to :label

  has_many :labels

  has_and_belongs_to_many :speech_parts

  field :name, type: String
  field :is_dialect, type: Boolean
  field :for_seq, type: Boolean, default: true
  field :for_meaning, type: Boolean, default: true

  index({:lang_id => 1})

end
