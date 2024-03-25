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

      expect(response).to have_http_status(:no_content)
    end
  end

  context 'when do not find project id' do
    project_nonexistent = { projectId: 100, updatedData: { title: 'INAO' } }


    it 'returns status code 400' do
      put :update_employees, params: project_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid project params' do
    before do
      technologies = Technology.create(name: 'Python')
      Employee.create(user_name: 'Cadu', technologies: [technologies])
    end

    project_to_update = { projectId: 1, updatedData: { title: 'Project Y', technologies: ['Python'], employees: ['Cadu'] } }

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
      technologies = Technology.create(name: 'React')
      Employee.create(user_name: 'Cardador', technologies: [technologies] )
    end
    employee_wrong_technologies = { projectId: 1, updatedData: { title: 'Project Y', employees: ['Cardador'] } }

    it 'returns status code 400' do
      put :update_employees, params: employee_wrong_technologies, as: :json

      expect(response).to have_http_status(:bad_request)
    end

  end
end
