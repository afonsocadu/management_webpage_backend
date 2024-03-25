# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TechnologiesController, type: :controller do
  before do
    FactoryBot.reload
    create_list(:technology, 2)
    technology = Technology.create(name: 'Rails')
  end

  context 'without technologies params' do
    it 'returns status code 400' do
      put :update, params: { id: 1 }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'when do not find technology param' do
    technology_nonexistent = { id: 100, name: 'Angular' }

    it 'returns status code 400' do
      put :update, params: technology_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid technology param' do
    technology_to_update = { id: 1, name: 'Python' }

    it 'returns 200' do
      put :update, params: technology_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated technology' do
      put :update, params: technology_to_update, as: :json

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Python')
    end
  end
end
