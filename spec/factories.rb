# frozen_string_literal: true

FactoryBot.define do
  factory :technology do
    sequence(:name) { |n| "Technology-#{n}" }
  end

  factory :project do
    title { 'Project X' }
    technologies { [association(:technology)] }
  end

  factory :employee do
    user_name { 'Amaral' }
    technologies { [association(:technology)] }
  end
end
