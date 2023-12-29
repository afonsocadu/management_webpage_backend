# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  before do
    FactoryBot.reload
    create_list(:project, 3)
    employee = Employee.create(user_name: 'Teresa', project_id: 1)
  end

  context 'without employee params' do
    it 'returns status code 400' do
       put :update, params: { id: 1 }

       expect(response).to have_http_status(:bad_request)
    end
  end

  context 'When do not find employee id' do
    employee_nonexistent = { id: 100, user_name: 'Cadu', project: 'Project 1' }

    it 'returns status code 400' do
      put :update, params: employee_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid employee params' do
    employee_to_update = { id: 1, user_name: 'Amaral', project: 'Project 2' }

    it 'returns 200' do
      put :update, params: employee_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated employee' do
      put :update, params: employee_to_update, as: :json

      json_response = JSON.parse(response.body)

      expect(json_response['user_name']).to eq('Amaral')
      expect(Project.find(json_response['project_id']).title).to eq('Project 2')
    end
  end
end
