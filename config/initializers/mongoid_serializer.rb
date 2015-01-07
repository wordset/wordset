Mongoid::Document.send(:include, ActiveModel::SerializerSupport)
Mongoid::Criteria.delegate(:active_model_serializer, to: :to_a)

ActiveModel::Serializer.setup do |config|
  config.embed = :ids
  config.embed_in_root = true
end

#Mongoid::Serializer.configure!
