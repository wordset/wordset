class NotificationSerializer < BaseSerializer
  attributes :id
  has_one :activity, serializer: ActivitySerializer
end
