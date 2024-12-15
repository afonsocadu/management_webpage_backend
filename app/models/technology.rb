class Technology < ApplicationRecord
  has_and_belongs_to_many :projects, join_table: 'projects_technologies'
  has_and_belongs_to_many :employees, join_table: 'employees_technologies'

  validates :name, presence: true, uniqueness: true
end
