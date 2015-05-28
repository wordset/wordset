module Wordsets
  module V1
    class Seqs < Grape::API
      include Wordsets::V1::Defaults
      include Garner::Cache::Context

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

        get '/:lang.list' do
          lang = Lang.where(code: params[:lang]).first
          garner.options(expires_in: 1.hour).bind(Seq) do
            {list: Seq.where(lang: lang).sort(text: 1).pluck("text").join(", ")}
          end
        end

        get '/:id' do
          Seq.lookup(params[:id])
        end
      end
    end
  end
end
