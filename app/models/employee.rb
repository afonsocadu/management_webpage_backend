class Employee < ApplicationRecord
  belongs_to :project, optional: true
  has_and_belongs_to_many :technologies

  validates :user_name, presence: true, uniqueness: true
  scope :available, -> { where(project_id: nil) }

  def self.can_be_associated_to_project(project_title)
    project = Project.find_by(title: project_title)
    joins(:technologies).where(technologies: { id: project.technologies.ids }).distinct
  end
end
