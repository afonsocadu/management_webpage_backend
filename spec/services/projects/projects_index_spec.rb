# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Projects::Index do
  let(:service) { described_class.new }

  let(:technology01) { create(:technology, name: 'Technology-1') }
  let(:technology02) { create(:technology, name: 'Technology-2') }
  let(:technology03) { create(:technology, name: 'Technology-3') }
  let(:technology04) { create(:technology, name: 'Technology-4') }

  let(:employee01) { create(:employee, user_name: 'User 01', technologies: [technology01, technology02, technology03, technology04]) }
  let(:employee02) { create(:employee, user_name: 'User 02', technologies: [technology01, technology02, technology03, technology04])}
  let(:employee03) { create(:employee, user_name: 'User 03', technologies: [technology01, technology02, technology03, technology04]) }
  let(:employee04) { create(:employee, user_name: 'User 04', technologies: [technology01, technology02, technology03, technology04]) }


  context 'when there are technologies and employees associated to projects' do
    before do
      create(:project, title: 'Project 01', employees: [employee01, employee02], technologies: [technology01, technology02])
      create(:project, title: 'Project 02', employees: [employee03, employee04], technologies: [technology03, technology04])
    end

    it 'returns projects with the correct associated employees and technologies' do
      response = service.call

      expect(response.find { |p| p[:title] == "Project 01" }).to include(
                                                                   id: 1,
                                                                   associated_employees: ["User 01", "User 02"],
                                                                   employees_available: ["User 01", "User 02", "User 03", "User 04"],
                                                                   technologies: ["Technology-1", "Technology-2"]
                                                                 )
      expect(response.find { |p| p[:title] == "Project 02" }).to include(
                                                                    id: 2,
                                                                    associated_employees: ["User 03", "User 04"],
                                                                    employees_available: ["User 01", "User 02", "User 03", "User 04"],
                                                                    technologies: ["Technology-3", "Technology-4"]
                                                                  )

    end

  end

  context 'when there are no employees associated to projects' do
    before do
      employee01
      employee02
      employee03
      employee04

      create(:project, title: 'Project 01', technologies: [technology01, technology02])
      create(:project, title: 'Project 02', technologies: [technology03, technology04])
    end

    it 'returns projects with the correct associated employees and technologies' do
      response = service.call

      expect(response.find { |p| p[:title] == "Project 01" }).to include(
                                                                   id: 1,
                                                                   associated_employees: [],
                                                                   employees_available: ["User 01", "User 02", "User 03", "User 04"],
                                                                   technologies: ["Technology-1", "Technology-2"]
                                                                 )
      expect(response.find { |p| p[:title] == "Project 02" }).to include(
                                                                   id: 2,
                                                                   associated_employees: [],
                                                                   employees_available: ["User 01", "User 02", "User 03", "User 04"],
                                                                   technologies: ["Technology-3", "Technology-4"]
                                                                 )

    end
  end

  context 'when there are no employee available and no technologies' do
    before do
      employee01
      employee02
      employee03
      employee04

      create(:project, title: 'Project 01', employees: [], technologies: [])
      create(:project, title: 'Project 02', employees: [], technologies: [])
    end

    it 'returns projects with the correct associated employees and technologies' do
      response = service.call

      expect(response.find { |p| p[:title] == "Project 01" }).to include(
                                                                   id: 1,
                                                                   associated_employees: [],
                                                                   employees_available: [],
                                                                   technologies: []
                                                                 )
      expect(response.find { |p| p[:title] == "Project 02" }).to include(
                                                                   id: 2,
                                                                   associated_employees: [],
                                                                   employees_available: [],
                                                                   technologies: []
                                                                 )
    end
  end

  context 'when there are no projects' do
    it 'returns projects with the correct associated employees and technologies' do

      expect(service.call).to eq([])
    end
  end
end
