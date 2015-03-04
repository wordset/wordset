class ProjectSerializer < BaseSerializer
  attributes :id, :name, :description, :percentage_complete,
             :fixed_targets_count, :pending_targets_count, :total_targets_count
end
