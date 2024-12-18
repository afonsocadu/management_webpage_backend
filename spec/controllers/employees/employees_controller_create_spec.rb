# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  login_user

  context 'When all params are valid' do
    let(:params) { { user_name: 'Amaral', project: 'Project 1', technologies: ['Name 1'] } }

    it 'returns status code 200' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'creates the Employee' do
      post :create, params: params, as: :json

      expect(Employee.all.size).to be(1)
    end
  end

  context 'without user_name param' do
    let(:params) { { project: 'Project 1' } }

    it 'returns status code 400' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'without title param' do
    let(:params) { { user_name: 'Amaral' } }

    it 'returns status code 400' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'without employees params' do
    let(:params) { {} }

    it 'returns status code 400' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end
end
