class MessageLink < Message
  belongs_to :link

  validates :link,
            associated: true,
            presence: true

  before_validation(on: :create) do
    self.link = Link.parse(text)
  end
end
