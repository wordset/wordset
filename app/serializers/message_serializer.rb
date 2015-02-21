class MessageSerializer < BaseSerializer
  attributes :id, :text, :created_at

  has_one :user, embed_key: :to_param
end
