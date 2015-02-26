class Domain
  include Mongoid::Document
  include Mongoid::Timestamps

  field :host, type: String

  has_many :links
end
