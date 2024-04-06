# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    technologies = Technology.create(name: 'Rails')
    Project.create(title: 'Project X', technologies: [technologies])
    Employee.create(user_name: 'Amaral', technologies: [technologies])
  end

  context 'without project params' do
    it 'returns status code 204' do
      put :update_employees, params: { updatedData: { projectId: 1 } }

      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when do not find project id' do
    project_nonexistent = { projectId: 100, updatedData: { title: 'INAO', employees: []  } }

    it 'returns status code 404' do
      put :update_employees, params: project_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid project params' do
    before do
      technologies = Technology.create(name: 'Python')
      Employee.create(user_name: 'Cadu', technologies: [technologies])
      Project.create(title: 'Project Y', technologies: [technologies])
    end

    project_to_update = { projectId: 2, updatedData: { title: 'Project Y', technologies: ['Python'], employees: ['Cadu'] } }

    it 'returns 200' do
      put :update_employees, params: project_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated employee' do
      put :update_employees, params: project_to_update, as: :json

      json_response = JSON.parse(response.body)

      expect(json_response[0]['user_name']).to eq('Cadu')
    end
  end

  context 'When the user lacks the required technologies for the project' do
    before do
      technologies_employee = Technology.create(name: 'React')
      Employee.create(user_name: 'Cardador', technologies: [technologies_employee] )

      technologies_project = Technology.create(name: 'Python')
      Project.create(id: 3, title: 'Project Z', technologies: [technologies_project])
    end
    employee_wrong_technologies = { projectId: 3, updatedData: { title: 'Project Y', employees: ['Cardador'] } }

    it 'returns status code 400' do
      put :update_employees, params: employee_wrong_technologies, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

  end
end
