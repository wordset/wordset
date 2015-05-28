module Wordsets
  module V1
    class Quizzes < Grape::API
      include Wordsets::V1::Defaults

      resource :quizzes do

        get "/", :each_serializer => QuizSerializer do
          Quiz.all.sort({published_at: -1}).to_a
        end

        get '/:id' do
          quiz = Quiz.where(slug: params[:id], state: "published").first
          quiz || Quiz.find(params[:id])
        end
      end
    end
  end
end
