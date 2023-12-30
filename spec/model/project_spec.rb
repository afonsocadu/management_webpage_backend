# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'association' do
    it { is_expected.to have_many(:employees)}
  end
end
