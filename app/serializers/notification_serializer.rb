class NotificationSerializer < BaseSerializer
  has_one :activity, serializer: ActivitySerializer
end
