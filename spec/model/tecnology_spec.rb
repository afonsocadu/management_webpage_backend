# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Technology, type: :model do
  describe 'association' do
    it { is_expected.to have_and_belong_to_many(:projects) }
    it { is_expected.to have_and_belong_to_many(:employees) }
  end
end
