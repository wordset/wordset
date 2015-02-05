module Wordset
  module V1
    class Proposals < Grape::API
      include Wordset::V1::Defaults

      resource :proposals do
        params do
          optional :limit, default: 25
          optional :offset, default: 0
        end
        get '/', each_serializer: ProposalSerializer do
          Proposal.includes(:user).limit(params[:limit]).sort({created_at: -1}).to_a
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
            throw "NOT IMPLMEENTED"
          when "NewMeaning"
            prop.word_id = d[:word_id]
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
      end
    end
  end
end
