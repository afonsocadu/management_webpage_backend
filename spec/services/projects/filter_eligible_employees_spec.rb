# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Projects::FilterEligibleEmployees do
  let(:employees_name) { ['User 01', 'User 02', 'User 02'] }
  let(:technology01) { create(:technology, name: 'Ruby') }
  let(:technology02) { create(:technology, name: 'Java') }
  let(:technology03) { create(:technology, name: 'Python') }
  let(:technology04) { create(:technology, name: 'Angular') }

  let(:project) { create(:project, technologies: [technology01, technology02]) }

  before do
    technology01
    technology02
    technology03
    technology04
  end

  context 'when employees have matching and non-matching technologies' do
    it 'correctly separates employees with and without matching technologies for the project' do
      # Employee 1 has at least one matching technology
      employee_01 = create(:employee, user_name: 'User 01', technologies: [technology02, technology03])
      employee_02 = create(:employee, user_name: 'User 02', technologies: [technology03, technology04])

      service = described_class.new(employees_name, project)
      result = service.call

      expect(result[:employee_to_update]).to include(employee_01)
      expect(result[:employees_not_updated]).to include(employee_02)
    end
  end

  context 'when employees have no matching technologies' do
    it 'correctly identifies employees without matching technologies' do
      # Employees have no matching technologies
      employee_01 = create(:employee, user_name: 'User 01', technologies: [technology03, technology04])
      employee_02 = create(:employee, user_name: 'User 02', technologies: [technology03])

      service = described_class.new(employees_name, project)
      result = service.call

      expect(result[:employee_to_update]).to be_empty
      expect(result[:employees_not_updated]).to include(employee_01, employee_02)
    end
  end

  context 'when employees have matching technologies' do
    it 'correctly identifies employees with matching technologies' do
      # Employees have matching technologies
      employee_01 = create(:employee, user_name: 'User 01', technologies: [technology01, technology02])
      employee_02 = create(:employee, user_name: 'User 02', technologies: [technology01])

      service = described_class.new(employees_name, project)
      result = service.call

      expect(result[:employee_to_update]).to include(employee_01, employee_02)
      expect(result[:employees_not_updated]).to be_empty
    end
  end

  context 'when employees_name is empty' do
    it 'returns empty arrays for both keys' do
      service = described_class.new([], project)
      result = service.call

      expect(result[:employee_to_update]).to be_empty
      expect(result[:employees_not_updated]).to be_empty
    end
  end
end
