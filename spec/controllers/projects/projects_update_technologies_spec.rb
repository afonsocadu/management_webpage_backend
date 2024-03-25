# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    technologies = Technology.create(name: 'Rails')
    Project.create(title: 'Project X', technologies: [technologies])
  end

  context 'without projects params' do
    it 'returns status code 204' do
      put :update_technologies, params: { projectId: 1 }

      expect(response).to have_http_status(:no_content)
    end
  end

  context 'when do not find project id' do
    project_nonexistent = { id: 100, title: 'INAO' }

    it 'returns status code 400' do
      put :update_technologies, params: project_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid project params' do
    before do
      Technology.create(name: 'Python')
    end

    project_to_update = { projectId: 1, updatedData: { title: 'Project Y', technologies: ['Python'] } }

    it 'returns 200' do
      put :update_technologies, params: project_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated employee' do
      put :update_technologies, params: project_to_update, as: :json

      json_response = JSON.parse(response.body)

      expect(json_response[0]['name']).to eq('Python')
    end
  end
end
