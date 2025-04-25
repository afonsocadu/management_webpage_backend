# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:service_instance) { instance_double(Projects::Index) }

  context 'When there are employees to list' do
    let(:mock_response) do
      [{
         id: 1,
         user_name: 'User 01',
          title: 'Project X',
         technologies: ['Technology-1', 'Technology-2']
       },
       {
         id: 2,
         user_name: 'User 02',
         title: 'Project Y',
         technologies: ['Technology-2', 'Technology-3']
       }
      ]
    end

    before do
      allow(Employees::Index).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:call).and_return(mock_response)
    end

    it 'renders a successful response' do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it 'calls the Employees::Index service' do
      get :index

      expect(service_instance).to have_received(:call)
    end

    it 'returns the right response' do
      get :index

      json_response = JSON.parse(response.body)
      expect(json_response[0]['user_name']).to eq('User 01')
      expect(json_response[0]['title']).to eq('Project X')
      expect(json_response[0]['technologies']).to eq( ["Technology-1", "Technology-2"])
    end
  end

  context 'when does not exist employees to list' do
    before do
      allow(Employees::Index).to receive(:new).and_return(service_instance)
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
