class ProposalSerializer < ActiveModel::Serializer
  attributes :id, :word_id, :state, :created_at, :wordnet,
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
    if !object.note.blank?
      h["note"] = object.note
    end
    if object.is_a? ProposeNewWord
      h["meanings"] = object.embed_new_word_meanings.collect do |m|
        {def: m.def,
         example: m.example,
         pos: m.pos,
         reason: m.reason}
      end
    elsif object.is_a? ProposeMeaningRemoval

    else
      h["def"] = object.def
      h["example"] = object.example
      h["original"] = object.original
      h["word_name"] = object.word.name
      if object.is_a? ProposeMeaningChange

      elsif object.is_a? ProposeNewMeaning
        h["pos"] = object.pos
      end
      h["word_id"] = object.word.name
    end
    h
  end
end
