# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  context 'When all params are valid' do
    let(:technologies) { create_list(:technology, 2) }

    before do
      create(:employee, user_name: 'Amaral', technologies: technologies)
    end

    let(:params) { { title: 'Direct', technologies: ['Rails'], employees: ['Amaral'] } }

    it 'returns status code 200' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'creates the Project' do
      post :create, params: params, as: :json

      expect(Project.all.size).to be(1)
    end
  end

  context 'without title param' do
    let(:params) {  }

    it 'returns status code 400' do
      post :create, params: params, as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end
end
