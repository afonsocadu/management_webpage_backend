# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    create_list(:project, 3)
  end

  context 'without project params' do
    it 'returns status code 400' do
      put :update, params: { id: 1 }

      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when do not find project id' do
    project_nonexistent = { id: 100, title: 'INAO' }

    it 'returns status code 400' do
      put :update, params: project_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid project params' do
    project_to_update = { id: 1, title: 'Project Y' }

    it 'returns 200' do
      put :update, params: project_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated employee' do
      put :update, params: project_to_update, as: :json

      json_response = JSON.parse(response.body)

      expect(json_response['title']).to eq('Project Y')
    end
  end
end
