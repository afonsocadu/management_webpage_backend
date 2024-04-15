# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  before do
    FactoryBot.reload
    technologies = create(:technology, name: 'Rails')
    project = create(:project, title: 'Project 1', technologies: [technologies])
    create(:employee, user_name: 'Teresa', project: project, technologies: [technologies])
  end

  context 'without employee params' do
    it 'returns status code 422' do
       put :update, params: { id: 1 }

       expect(response).to have_http_status(:ok)
    end
  end

  context 'When do not find employee id' do
    employee_nonexistent = { id: 100, user_name: 'Cadu', project: 'Project 1' }

    it 'returns status code 404' do
      put :update, params: employee_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid employee params' do
    before do
      technology = create(:technology, name: 'Python')
      create(:project, title: 'Project 2', technologies: [technology])
    end
    employee_to_update = { id: 1, user_name: 'Amaral', project: 'Project 2', technology: [["Rails", "Angular", "React"]] }

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
