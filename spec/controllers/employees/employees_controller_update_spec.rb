# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:technologies) { create_list(:technology, 2) }
  let(:project) { create(:project, title: 'Project 1', technologies: technologies) }

  before do
    create(:employee, user_name: 'User 01', project: project, technologies: technologies)
  end

  context 'without employees params' do
    it 'returns status code 200' do
       put :update, params: { id: 1 }

       expect(response).to have_http_status(:ok)
    end
  end

  context 'When do not find employees id' do
    let(:employee_nonexistent) { { id: 100, user_name: 'Cadu', project: 'Project 1' } }

    it 'returns status code 404' do
      put :update, params: employee_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid employees params' do
    let(:service_instance) { instance_double(Employees::Update) }
    let(:project) { create(:project, title: 'Project 2') }
    let(:technology) { create(:technology, name: 'Rails') }
    let(:employee_to_update) { { id: 1, user_name: 'User Updated', project: 'Project 2', technology: ['Rails'] } }

    let(:mock_response) do
      {
        id: 1,
        user_name: 'User Updated',
        project: project,
        technologies: [technology]
      }
    end

    before do
      allow(Employees::Update).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:call).and_return(mock_response)
    end

    it 'returns 200' do
      put :update, params: employee_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated employees' do
      put :update, params: employee_to_update, as: :json

      json_response = JSON.parse(response.body)

      expect(json_response['user_name']).to eq('User Updated')
      expect(Project.find(json_response['project_id']).title).to eq('Project 2')
    end
  end
end
