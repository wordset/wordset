class MessageSerializer < BaseSerializer
  attributes :id, :text, :created_at, :type

  has_one :user, embed_key: :to_param

  def type
    object._type[7..-1].downcase
  end

end
