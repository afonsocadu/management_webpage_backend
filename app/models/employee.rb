class Employee < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :technologies

  validates :user_name, presence: true
end
