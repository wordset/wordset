class Lang
  include Mongoid::Document

  field :code
  field :name

  index({code: 1})

  has_many :speech_parts
  has_many :seqs
  has_many :proposals
  has_many :wordsets
  has_many :posts
  has_many :projects
  has_many :labels
  has_many :quizzes

  belongs_to :featured_project, class_name: "Project"

end
