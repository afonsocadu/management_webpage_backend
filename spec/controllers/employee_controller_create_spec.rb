# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do

  context 'When all params are valid' do
    let(:params) do { user_name: 'Amaral', project: 'Project 1' } end

    before do
      FactoryBot.reload
      create(:project)
    end

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
    let(:params) do {  project: 'Project 1' } end


    it 'returns status code 400' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:no_content)
    end
  end

  context 'without title param' do
    let(:params) do { user_name: 'Amaral' } end


    it 'returns status code 400' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:no_content)
    end
  end

  context 'without employee params' do
    let(:params) do {  } end


    it 'returns status code 400' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:no_content)
    end
  end
end
