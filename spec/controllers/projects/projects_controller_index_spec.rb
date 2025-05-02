# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:service_instance) { instance_double(Projects::Index) }

  context 'When there are projects to list' do
    let(:mock_response) { create(:project, title: 'Project 01') }

    before do
      allow(Projects::Index).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:call).and_return([mock_response])
    end

    it 'renders a successful response' do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it 'returns the right response' do
      get :index

      json_response = JSON.parse(response.body)
      expect(json_response[0]['title']).to eq('Project 01')
    end

    it 'calls the Projects::Index service' do
      get :index

      expect(service_instance).to have_received(:call)
    end
  end

  context 'when does not exist projects to list' do

    before do
      allow(Projects::Index).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:call).and_return([])
    end

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
