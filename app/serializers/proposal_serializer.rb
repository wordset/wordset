class ProposalSerializer < ActiveModel::Serializer
  attributes :id, :wordset_id, :state, :created_at, :wordnet,
             :user_id, :reason, :type, :tally, :flagged, :word_name
  has_one :user, embed_key: :to_param
  has_many :votes
  has_many :activities, serializer: ActivitySerializer
  has_one :meaning
  has_one :project

  def type
    object._type[7..-1]
  end

  def meaning
    if object.is_a? ProposeMeaningChange
      return object.meaning
    else
      return nil
    end
  end

  def flagged
    object.flagged?
  end

  def attributes
    h = super
    modules = object.class.included_modules
    if !object.note.blank?
      h["note"] = object.note
    end
    if object.is_a? ProposeNewWordset
      h["meanings"] = object.embed_new_word_meanings.collect do |m|
        {def: m.def,
         example: m.example,
         pos: m.pos,
         reason: m.reason}
      end
    end
    if object.is_a? ProposeNewMeaning
      h["pos"] = object.pos
    end
    if modules.include?(MeaningProposalLike)
      h["original"] = object.original
      h["word_name"] = object.word_name || object.wordset.name
      (h["word_id"] = object.wordset.id) if object.wordset
    end
    if modules.include?(MeaningLike)
      h["def"] = object.def
      h["example"] = object.example
    end
    h
  end
end
