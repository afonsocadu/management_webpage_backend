# frozen_string_literal: true

FactoryBot.define do
  factory :technology do
    sequence(:name) { |n| "Name #{n}" }
  end

  factory :project do
    sequence(:title) { |n| "Project #{n}" }
  end

  factory :employee do
    sequence(:user_name) { |n| "Name #{n}" }
  end
end
