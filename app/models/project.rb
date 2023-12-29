class Project < ApplicationRecord
  has_many :employees

  validates :title, presence: true, uniqueness: true
end
