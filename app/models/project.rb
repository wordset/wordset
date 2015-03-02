class Project
  include Mongoid::Document

  has_many :project_targets
  has_many :proposals

  field :name, type: String
  field :description, type: String
  field :start_at, type: Time

  def self.create_parans_project
    proj = Project.create(name: "Parantheses Roundup", description: "Getting rid of parantheses in definitions.")
    Meaning.where({ def: /[\(\)]+/}).each do |meaning|
      proj.project_targets.create(meaning: meaning)
    end
  end

  def total_targets
    self.project_targets.count
  end

  def fixed_targets
    self.project_targets.where(state: "fixed").count
  end

  def percentage_complete
    ((fixed_targets/total_targets).to_f * 100)
  end

end
