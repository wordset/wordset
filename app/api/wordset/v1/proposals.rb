module Wordset
  module V1
    class Proposals < Grape::API
      include Wordset::V1::Defaults

      resource :proposals do
        params do
          optional :limit, default: 25, type: Integer
          optional :needs_my_vote, type: Boolean, default: nil
          optional :random, type: Boolean, default: false
          optional :word_id
          optional :offset, default: 0, type: Integer
          optional :flagged
        end
        get '/', each_serializer: ProposalSerializer do
          p = Proposal.includes(:user).includes(:activities)
          if params[:word_id]
            p = p.where(word: Word.lookup(params[:word_id]))
          end
          if params[:user_id]
            user = User.where(username: params[:user_id]).first
            if user == nil
              raise "No such user"
            end
            p = p.where(user_id: user.id)
          end
          if params[:flagged] == false
            p = p.ne(state: "flagged")
          elsif params[:flagged] == true
            p = p.where(state: "flagged")
          end
          if params[:needs_my_vote] == true
            authorize!
            p = p.open.nin(id: current_user.voted_proposal_ids)
          end
          count = p.count
          if params[:random] == true
            p = p.offset(rand(p.count))
          elsif params[:offset]
            p = p.offset(params[:offset])
          end
          render p.limit(params[:limit])
                 .sort({created_at: -1})
                 .to_a,
                 { meta: { total: count } }
        end


        get '/:id', serializer: ProposalSerializer do
          Proposal.find(params[:id])
        end

        params do
          requires :proposal, type: Hash do
            requires :type, type: String
            optional :reason, type: String

            optional :meanings # NewWord
            optional :name # NewWord

            optional :def # Meaning
            optional :example # Meaning
            optional :meaning_id # MeaningChange
            optional :word_id # NewMeaning
            optional :pos # NewMeaning
          end
        end
        post '/', serializer: ProposalSerializer do
          authorize!
          d = params[:proposal]
          prop = nil
          case d[:type]
          when "NewWord"
            prop = ProposeNewWord.new
          when "NewMeaning"
            prop = ProposeNewMeaning.new
          when "MeaningChange"
            prop = ProposeMeaningChange.new
          end
          prop.reason = d[:reason]
          prop.user = current_user

          case d[:type]
          when "NewWord"
            prop.name = d[:word_name]
            d[:meanings].each do |meaning|
              prop.embed_new_word_meanings.build(def: meaning[:def],
                                            pos: meaning[:pos],
                                            example: meaning[:example],
                                            reason: meaning[:reason])
            end
          when "NewMeaning"
            prop.word = Word.lookup(d[:word_id])
            prop.def = d[:def]
            prop.example = d[:example]
            prop.pos = d[:pos]
          when "MeaningChange"
            meaning = Meaning.find(d[:meaning_id])
            prop.meaning = meaning
            prop.def = d[:def]
            prop.example = d[:example]
            prop.proposal = meaning.accepted_proposal || meaning.word.proposals.first
            if prop.save
              meaning.open_proposal = prop
            end
          end
          prop.save!
          prop
        end


        get '/new-word-status/:word' do
          word = Word.where(name: params[:word]).first
          if word
            return {word_id: word.name, can: false}
          end
          prop = ProposeNewWord.where(name: params[:word]).open.first
          if prop
            return {proposal_id: prop.id, can: false}
          end
          return {can: true}
        end

        params do
          requires :proposal, type: Hash do
            optional :reason, type: String
            optional :meanings, type: Array # NewWord

            optional :def # Meaning
            optional :example # Meaning
            optional :pos # NewMeaning
          end
        end
        put '/:id', serializer: ProposalSerializer  do
          authorize!
          prop = current_user.proposals.where(state: "open").find(params[:id])
          d = params[:proposal]
          if prop.class == ProposeNewMeaning
            prop.def = d[:def]
            prop.example = d[:example]
            prop.pos = d[:pos]
          elsif prop.class == ProposeNewWord
            prop.embed_new_word_meanings.each &:destroy
            d[:meanings].each do |meaning|
              prop.embed_new_word_meanings.build(def: meaning[:def],
                                            pos: meaning[:pos],
                                            example: meaning[:example],
                                            reason: meaning[:reason])
            end
          elsif prop.class == ProposeMeaningChange
            prop.def = d[:def]
            prop.example = d[:example]
          end
          prop.reason = d[:reason]
          prop.save!
          prop.finished_edit!
          prop
        end

      end
    end
  end
end
