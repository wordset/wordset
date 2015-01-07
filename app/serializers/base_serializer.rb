require_relative '../../lib/bson'

class BaseSerializer < ActiveModel::Serializer
  include ActiveModel::Serialization
end
