class MessageSerializer < BaseSerializer
  attributes :id, :text, :created_at, :type, :url

  has_one :user, embed_key: :to_param

  def type
    object._type[7..-1].downcase
  end

  def url
    if object.class == MessageLink
      object.link.url
    end
  end

end
