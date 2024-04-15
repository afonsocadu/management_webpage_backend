# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    technology = create(:technology, name: 'Rails')
    create(:project, title: 'Project X', technologies: [technology])
  end

  context 'without projects params' do
    it 'returns status code 400' do
      put :update, params: { id: 1 }

      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when do not find project id' do
    project_nonexistent = { id: 100, title: 'INAO' }

    it 'returns status code 404' do
      put :update, params: project_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid project params' do
    project_to_update = { id: 1, updated_data: { project_name: 'Project Y' } }

    it 'returns 200' do
      put :update, params: project_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end
  end
end
