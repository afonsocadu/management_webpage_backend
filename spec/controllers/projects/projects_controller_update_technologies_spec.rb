# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:technology_01) { create(:technology, name: 'Technology-1') }
  let(:technology_02) { create(:technology, name: 'Technology-2') }

  let(:project) { create(:project, title: 'Project 01', technologies: [technology_01]) }

  before do
    technology_01
    technology_02
  end

  context 'when the project is updated successfully' do
    it 'return status 200' do
      put :update_technologies, params: { project_id: project.id, updated_data: { technologies: ['Technology-2'] } }

      expect(response).to have_http_status(:ok)
    end

    it 'updates the project with the new technologies and returns the correct response' do
      put :update_technologies, params: { project_id: project.id, updated_data: { technologies: ['Technology-2'] } }

      json_response = JSON.parse(response.body)

      expect(json_response).to include(
                                 a_hash_including('name' => 'Technology-2', 'id' => technology_02.id)
                               )
    end
  end

  context 'when param project_id is not provided or is wrong' do
    it 'returns an error' do
      put :update_technologies, params: { updated_data: { technologies: ['Technology-2'] } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to include("Resource not found")
    end

    it 'returns an error' do
      put :update_technologies, params: { project_id: 99, updated_data: { technologies: ['Technology-2'] } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to include("Resource not found")
    end
  end

  context 'param updated_data is not provided' do
    it 'returns an error' do
      put :update_technologies, params: { project_id: project.id }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to include("param is missing or the value is empty")
    end
  end

  context 'when technologies are not provided' do
    it 'returns an error' do
      put :update_technologies, params: { project_id: project.id, updated_data: {} }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to include("param is missing or the value is empty")
    end
  end
end
