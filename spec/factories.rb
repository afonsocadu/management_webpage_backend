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

  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { '1234' }
    password_confirmation{ '1234' }
  end
end
