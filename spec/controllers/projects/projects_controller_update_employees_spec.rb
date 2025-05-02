# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:technology_01) { create(:technology, name: 'Technology-1') }
  let(:employee_01) { create(:employee, user_name: 'User 01', technologies: [technology_01]) }
  let(:employee_02) { create(:employee, user_name: 'User 02', technologies: [technology_01]) }

  let(:project) { create(:project, title: 'Project 01', employees: [employee_01, employee_02], technologies: [technology_01]) }
  let(:service_instance) { instance_double(Projects::FilterEligibleEmployees) }

  before do
    project

    allow(Projects::FilterEligibleEmployees).to receive(:new).and_return(service_instance)
    allow(service_instance).to receive(:call).and_return({
                                                           employee_to_update: [employee_02]
                                                         })
  end

  context 'when the project is updated successfully' do
    it 'return status 200' do
      put :update_employees, params: { project_id: project.id, updated_data: { employees: ['User 02'] } }

      expect(response).to have_http_status(:ok)
    end

    it 'updates the project with the new employees and returns the correct response' do
      put :update_employees, params: { project_id: project.id, updated_data: { employees: ['User 02'] } }

      json_response = JSON.parse(response.body)

      expect(json_response['employees_not_updated']).to be_nil
      expect(json_response['updated_employees']).to include(
                                                      a_hash_including(
                                                        'user_name' => 'User 02',
                                                        'project_id' => employee_02.project_id
                                                      )
                                                    )
    end
  end

  context 'when param project_id is not provided' do
    it 'returns an error' do
      put :update_employees, params: { updated_data: { employees: ['User 02'] } }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to include("param is missing or the value is empty")
    end
  end

  context 'when the project is not found' do
    it 'returns an error' do
      put :update_employees, params: { project_id: 999, updated_data: { employees: ['User 02'] } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq("Resource not found.")
    end
  end

  context 'when the param employees is not provided' do
    before do
      allow(Projects::FilterEligibleEmployees).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:call).and_return({:employee_to_update=>[], :employees_not_updated=>[]})
    end
    it 'return status 200' do
      put :update_employees, params: { project_id: project.id, updated_data: {} }

      expect(response).to have_http_status(:ok)
    end

    it 'Update the project to have no assigned employee' do
      put :update_employees, params: { project_id: project.id, updated_data: {} }

      json_response = JSON.parse(response.body)

      expect(json_response['employees_not_updated']).to be_nil
      expect(json_response['updated_employees']).to be_empty
    end
  end
end
