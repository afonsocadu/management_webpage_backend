# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:service_instance) { instance_double(Employees::Create) }

  let(:technologies) { create_list(:technology, 2) }
  let(:project) { create(:project, title: 'Project 1', technologies: technologies) }
  let(:employee) { create(:employee, user_name: 'User 01', project: project, technologies: technologies) }

  before do
    create(:technology, name: 'Technology 1')
    create(:technology, name: 'Technology 2')
  end

  context 'When all params are valid' do
    before do
      allow(Employees::Create).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:call).and_return(employee)
    end

    let(:params) { { user_name: 'User 01', project: 'Project 1', technologies: ['Technology 1', 'Technology 2'] } }

    it 'returns status code 200' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'calls the Employees::Create service' do
      post :create, params: params, as: :json

      expect(service_instance).to have_received(:call)
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
    let(:params) { { user_name: 'User 01' } }

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
