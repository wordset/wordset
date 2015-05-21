class ProjectSerializer < BaseSerializer
  attributes :id, :name, :description, :long_description, :rules, :percentage_complete,
             :fixed_targets_count, :pending_targets_count, :total_targets_count
end
