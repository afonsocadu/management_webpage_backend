class Project < ApplicationRecord
  has_many :employees, dependent: :nullify

  validates :title, presence: true, uniqueness: true
end
