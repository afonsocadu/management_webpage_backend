# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
  end
end
