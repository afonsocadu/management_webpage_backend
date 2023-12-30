# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  context 'When there are employees to list' do
    it 'renders a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns the right response' do
      project = Project.create(title: 'Indirect')
      Employee.create(user_name: 'Amaral', project: project)

      get :index
      json_response = JSON.parse(response.body)

      expect(json_response[0]['user_name']).to eq('Amaral')
      expect(json_response[0]['title']).to eq('Indirect')
    end
  end

  context 'when does not exist employee to list' do
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
