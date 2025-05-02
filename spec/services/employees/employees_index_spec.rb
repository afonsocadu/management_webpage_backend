# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employees::Index do
  let(:service) { described_class.new }

  context 'when there are employees with projects and technologies' do
    let(:technologies) { create_list(:technology, 2) }
    let(:project) { create(:project, technologies: technologies) }

    before do
      create(:employee, user_name: 'User 01', technologies: technologies, project: project)
    end

    it 'returns a list of employees with their technologies' do
      response = service.call

      expect(response[0][:user_name]).to eq('User 01')
      expect(response[0][:title]).to eq('Project X')
      expect(response[0][:technologies]).to eq(technologies.map(&:name))
    end
  end

  context 'when employee has no project' do
    let!(:employee) { create(:employee, project: nil) }

    it 'returns title as nil' do
      response = service.call

      expect(response.first[:title]).to be_nil
    end
  end

  context 'when there are no employees' do
    it 'returns an empty array' do
      response = service.call

      expect(response).to eq([])
    end
  end
end
