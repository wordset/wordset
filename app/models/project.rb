class Project
  include Mongoid::Document
  include BelongsToLang

  has_many :project_targets
  has_many :proposals
  has_many :badges

  field :name, type: String
  field :slug, type: String
  field :description, type: String
  field :long_description, type: String
  field :rules, type: String
  field :start_at, type: Time

  field :total_targets_count, type: Integer
  field :pending_targets_count, type: Integer
  field :fixed_targets_count, type: Integer
  field :percentage_complete, type: Integer

  validates :name, presence: true
  validates :slug, presence: true
  validates :lang_id, presence: true

  index({slug: 1})
  index({lang_id: 1, slug: 1})
  index({slug: 1, lang_code: 1})

  def self.create_parans_project
    proj = Project.create(name: "Parantheses Roundup", description: "Getting rid of parantheses in definitions.")
    Meaning.where({ def: /[\(\)]+/}).each do |meaning|
      proj.project_targets.create(meaning: meaning)
    end
  end

  def recalculate_counts!
    self.total_targets_count = self.project_targets.count
    self.pending_targets_count = self.project_targets.pending.count
    self.fixed_targets_count = self.project_targets.fixed.count
    self.percentage_complete = ((fixed_targets_count/total_targets_count.to_f) * 100).to_i
    save!
  end

  def add_target(meaning)
    if project_targets.where(meaning: meaning).none?
      project_targets.create(meaning: meaning)
    end
  end

end
