# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  before do
    FactoryBot.reload
    @project = create(:project)
    @technology = create_list(:technology, 3)

  end

  context 'When there are employees to list' do
    it 'renders a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns the right response' do
      #project = Project.create(title: 'Indirect')
      employee = Employee.create(user_name: 'Amaral', project: @project)
      employee.technologies << @technology

      get :index
      json_response = JSON.parse(response.body)

      expect(json_response[0]['user_name']).to eq('Amaral')
      expect(json_response[0]['title']).to eq('Project 1')
      expect(json_response[0]['technologies']).to eq( ["Name 1", "Name 2", "Name 3"])
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
