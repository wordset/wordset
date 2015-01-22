class SuggestionSerializer < BaseSerializer
  attributes :id, :target_id, :target_type, :word_id, :user, :delta
end
