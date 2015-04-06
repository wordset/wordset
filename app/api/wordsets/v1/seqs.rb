module Wordsets
  module V1
    class Seqs < Grape::API
      include Wordsets::V1::Defaults

      resource :seqs do
        get '/:id' do
          Seq.lookup(params[:id])
        end
      end
    end
  end
end
