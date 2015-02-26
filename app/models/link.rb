class Link
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :domain
  has_many :messages

  field :path, type: String
  field :internal_link, type: Boolean, default: false

  validates :domain,
            :presence => {
              message: "you can only link to approved domains."
            },
            :unless => :internal_link

  def self.parse(input)
    link = Link.new
    begin
      uri = URI(input)
      if uri.host
        link.domain = Domain.where(host: uri.host).first
      else
        link.internal_link = true
      end
      link.path = uri.path
      if uri.query
        link.path += ("?" + uri.query)
      end
    rescue URI::InvalidURIError
      throw "Invalid url"
    end
    link
  end
end
