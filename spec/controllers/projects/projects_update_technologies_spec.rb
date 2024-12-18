# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  login_user
  let(:technologies) { create(:technology, name: 'Rails') }

  before do
    create(:project, title: 'Project X', technologies: [technologies])
  end

  context 'without projects params' do
    it 'returns status code 404' do
      put :update_technologies, params: { projectId: 1 }

      expect(response).to have_http_status(:not_found )
    end
  end

  context 'when do not find project id' do
    let(:project_nonexistent) { { id: 100, title: 'INAO' } }

    it 'returns status code 400' do
      put :update_technologies, params: project_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid project params' do
    let(:project_to_update) { { project_id: 1, updated_data: { title: 'Project Y', technologies: ['Python'] } } }

    before do
      create(:technology, name: 'Python')
    end

    it 'returns 200' do
      put :update_technologies, params: project_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated employees' do
      put :update_technologies, params: project_to_update, as: :json

      json_response = JSON.parse(response.body)

      expect(json_response[0]['name']).to eq('Python')
    end
  end
end
