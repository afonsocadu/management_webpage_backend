# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    Project.create(title: 'Project X')
  end

  context 'without projects params' do
    it 'returns status code 204' do
      put :update_title, params: { projectId: 1 }

      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when do not find project id' do
    project_nonexistent = { id: 100, title: 'INAO' }

    it 'returns status code 400' do
      put :update_title, params: project_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid project params' do
    project_to_update = { projectId: 1, updatedData: { projectName: 'Project Y' } }

    it 'returns 200' do
      put :update_title, params: project_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

  end
end
