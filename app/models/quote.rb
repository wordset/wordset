
class Quote
  include Mongoid::Document
  field :text, type: String
  field :source, type: String
  field :url, type: String
  belongs_to :meaning
end
