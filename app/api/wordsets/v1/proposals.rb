module Wordsets
  module V1
    class Proposals < Grape::API
      include Wordsets::V1::Defaults

      resource :proposals do
        params do
          optional :limit, default: 25, type: Integer
          optional :random, type: Boolean, default: false
          optional :wordset_id
          optional :offset, default: 0, type: Integer
          optional :flagged
        end
        get '/', each_serializer: ProposalSerializer do
          p = Proposal
          if params[:wordset_id]
            p = p.where(wordset: Wordset.find(params[:wordset_id]))
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
          count = p.count
          if params[:random] == true
            p = p.offset(rand(p.count))
          elsif params[:offset]
            p = p.offset(params[:offset])
          end
          render p.limit(params[:limit])
                 .includes(:user, :votes)
                 .sort({created_at: -1})
                 .to_a,
                 { meta: { total: count } }
        end


        params do
          optional :proposal_id
        end
        get '/next' do
          authorize!

          proposal = Proposal.open.
                      not.in(vote_user_ids: current_user.id).
                      order(points: 1).first
          if proposal.nil?
            render "No more proposals to vote on", status: "404"
          else
            ProposalSerializer.new(proposal)
          end
        end


        get '/:id', serializer: ProposalSerializer do
          Proposal.find(params[:id])
        end


        params do
          requires :proposal, type: Hash do
            requires :type, type: String
            optional :reason, type: String

            optional :meanings # NewWordset            optional :name # NewWordset
            optional :def # Meaning
            optional :example # Meaning

            optional :meaning_id # MeaningChange / #MeaningRemoval
            optional :word_id # NewMeaning
            optional :pos # NewMeaning

            optional :project_id # If associated with a project
          end
        end
        post '/', serializer: ProposalSerializer do
          authorize!
          d = params[:proposal]
          prop = nil
          case d[:type]
          when "NewWordset"
            prop = ProposeNewWordset.new(name: d[:word_name])
            d[:meanings].each do |meaning|
              prop.embed_new_word_meanings.build(def: meaning[:def],
                                            pos: meaning[:pos],
                                            example: meaning[:example],
                                            reason: meaning[:reason])
            end
          when "NewMeaning"
            prop = ProposeNewMeaning.new(word: Wordset.find(d[:wordset_id]),
                                         pos: d[:pos])
          when "MeaningChange"
            prop = ProposeMeaningChange.new
          when "MeaningRemoval"
            prop = ProposeMeaningRemoval.new(meaning: d[:meaning_id])
          end
          prop.reason = d[:reason]
          prop.user = current_user
          prop.lang = current_lang

          modules = prop.class.included_modules

          if modules.include?(MeaningLike)
            prop.def = d[:def]
            prop.example = d[:example]
          end
          if modules.include?(MeaningProposalLike)
            meaning = Meaning.find(d[:meaning_id])
            prop.meaning = meaning

            prop.project_id = d[:project_id]
            if prop.save
              meaning.open_proposal = prop
            end
          end
          prop.save!
          prop
        end


        get '/new-word-status/:word' do
          seq = Seq.where(text: params[:word], :wordset_id.ne => nil).first
          if seq
            return {seq_id: seq.text, can: false}
          end
          prop = ProposeNewWordset.where(name: params[:word]).open.first
          if prop
            return {proposal_id: prop.id, can: false}
          end
          return {can: true}
        end

        post '/:id/withdraw', serializer: ProposalSerializer do
          authorize!
          prop = Proposal.where(user: current_user, state: "open", id: params[:id]).first
          prop.withdraw!
          prop.pushUpdate!
          prop
        end

        params do
          requires :proposal, type: Hash do
            optional :reason, type: String
            optional :meanings, type: Array # NewWordset
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
          elsif prop.class == ProposeNewWordset
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
          prop.pushUpdate!
          prop.finished_edit!
          prop
        end

      end
    end
  end
end
