# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:project).optional }
    it { is_expected.to have_and_belong_to_many(:technologies) }
  end
end
