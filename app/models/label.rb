class Label
  include Mongoid::Document

  include BelongsToLang

  belongs_to :parent, :class_name => "Label"
  has_many :children, :class_name => "Label", inverse_of: "parent"

  has_and_belongs_to_many :speech_parts

  field :name, type: String
  field :is_dialect, type: Boolean
  field :for_seq, type: Boolean, default: true
  field :for_meaning, type: Boolean, default: true
end
