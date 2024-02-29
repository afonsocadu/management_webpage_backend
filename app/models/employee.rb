class Employee < ApplicationRecord
  belongs_to :project, optional: true
  has_and_belongs_to_many :technologies

  validates :user_name, presence: true, uniqueness: true
end
