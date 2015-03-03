class ProjectSerializer < BaseSerializer
  attributes :id, :name, :description, :percentage_complete, :fixed_targets, :pending_targets, :total_targets

end
