class ProposalSerializer < ActiveModel::Serializer
  attributes :id, :word_id, :state, :created_at, :wordnet,
             :user_id, :reason, :type
  has_one :user, embed_key: :to_param
  has_many :votes

  def type
    object._type[7..-1]
  end

  def attributes
    h = super
    if object.is_a? ProposeNewWord
      h["meanings"] = object.embed_new_word_meanings.collect do |m|
        {def: m.def,
         example: m.example,
         pos: m.pos}
      end
      h["word_name"] = object.name
    else
      h["def"] = object.def
      h["example"] = object.example
      h["word_name"] = object.word.name
      if object.is_a? ProposeMeaningChange
        h["meaning_id"] = object.meaning_id
        h["original"] = object.original
        h["parent_id"] = object.proposal_id
      elsif object.is_a? ProposeNewMeaning
        h["pos"] = object.pos
      end
      h["word_id"] = object.word_id
    end
    h
  end
end
