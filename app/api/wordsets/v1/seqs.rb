module Wordsets
  module V1
    class Seqs < Grape::API
      include Wordsets::V1::Defaults

      resource :seqs do
        get '/:lang/:id' do
          Seq.lookup(params[:lang], params[:id])
        end
      end
    end
  end
end
