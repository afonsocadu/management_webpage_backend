class Employee < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :technologies, join_table: 'employees_technologies'

  validates :user_name, presence: true
end
