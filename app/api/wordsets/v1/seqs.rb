module Wordsets
  module V1
    class Seqs < Grape::API
      include Wordsets::V1::Defaults

      resource :seqs do

        params do
          requires :langs
        end
        get '/' do
          langs = params[:langs].split(",")
          random_lang = Lang.where(:code.in => langs)
                             .limit(1)
                             .offset(rand(langs.count)).first
          random_lang.seqs
            .where(:wordset_id.ne => nil)
            .limit(1)
            .offset(rand(Seq.count))
        end

        get '/:id' do
          Seq.lookup(params[:id])
        end
      end
    end
  end
end
