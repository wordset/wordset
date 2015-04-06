module Wordsets
  module V1
    class Projects < Grape::API
      include Wordset::V1::Defaults

      resource :projects do
        # TODO: Make this use real logic!
        get '/current', serializer: ProjectSerializer do
          Project.find("54f4fd486461370003000000")
        end

        get '/:id', serializer: ProjectSerializer do
          Project.find(params[:id])
        end

        get '/:id/next', serializer: MeaningSerializer do
          todos = Project.find(params[:id]).project_targets.todo
          todos.offset(rand(todos.count)).limit(1).first.meaning
        end
      end
    end
  end
end
