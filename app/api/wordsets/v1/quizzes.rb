module Wordsets
  module V1
    class Quizzes < Grape::API
      include Wordsets::V1::Defaults

      resource :quizzes do
        get '/' do
          Quiz.all
        end
      end
    end
  end
end
