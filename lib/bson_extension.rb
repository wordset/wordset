require "garner/mixins/mongoid"

module BSON
  class ObjectId
    def as_json(*args)
      to_s
    end
  end
end


module Mongoid
  module Document
    include Garner::Mixins::Mongoid::Document
  end
end
