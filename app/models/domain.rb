class Domain
  include Mongoid::Document
  include Mongoid::Timestamps

  field :host, type: String

  has_many :links

  def self.bootstrap
    [
      "en.wikipedia.org",
      "www.nytimes.com",
      "books.google.com"
    ]
  end

end
