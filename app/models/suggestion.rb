class Suggestion
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :word
  belongs_to :user

  field :entries, type: Array, as: "e"
  field :status, type: String, as: "s"
  field :source, type: String
end
