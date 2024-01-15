# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:project) }
  end
end
