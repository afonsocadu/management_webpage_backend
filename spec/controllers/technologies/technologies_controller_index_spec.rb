# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TechnologiesController, type: :controller do
  login_user
  context 'When there are technologies to list' do
    it 'renders a successful response' do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it 'returns the right response' do
      create(:technology, name: 'Rails')

      get :index

      json_response = JSON.parse(response.body)
      expect(json_response[0]['name']).to eq('Rails')

    end
  end

  context  'When does not exist projects to list' do
    it 'returns 200' do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it 'returns empty array' do
      get :index

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to be_empty
    end
  end
end
