class Project < ApplicationRecord
  has_many :employees, dependent: :nullify
  has_and_belongs_to_many :technologies

  validates :title, presence: true, uniqueness: true
end
