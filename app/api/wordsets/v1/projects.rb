module Wordsets
  module V1
    class Projects < Grape::API
      include Wordsets::V1::Defaults

      resource :projects do
        helpers do
          def current_project
            Project.where(slug: params[:id]).first || Project.find(params[:id])
          end
        end
        
        get '/:id', serializer: ProjectSerializer do
          current_project
        end

        get '/:id/next', serializer: MeaningSerializer do
          todos = current_project.project_targets.todo
          todos.offset(rand(todos.count)).limit(1).first.meaning
        end


      end
    end
  end
end
