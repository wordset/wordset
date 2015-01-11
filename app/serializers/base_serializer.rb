require_relative '../../lib/bson_extension'

class BaseSerializer < ActiveModel::Serializer
  include ActiveModel::Serialization
end
