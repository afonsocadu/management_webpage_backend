# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'association' do
    it { is_expected.to have_many(:employees) }
    it { is_expected.to have_and_belong_to_many(:technologies) }
    it 'has factory that produces a valid project' do
      project = create(:project)

      expect(project).to be_valid
    end
  end
end
