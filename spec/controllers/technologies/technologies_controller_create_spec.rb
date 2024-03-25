# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TechnologiesController, type: :controller do
  context 'when param is valid' do
    let(:param) { { name: 'Rails' } }

    it 'returns status code 200' do
      post :create, params: param, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'create the Technology' do
      post :create, params: param, as: :json

      expect(Technology.all.size).to be(1)
    end
  end

  context 'without name param' do
    let(:no_param) { { } }

    it 'returns status code 400' do
      post :create, params: no_param, as: :json

      expect(response).to have_http_status(:bad_request)
    end
  end
end

#Não percebo o motivo,mas eu tenho isso
# Technology.all
# #<ActiveRecord::Relation [#<Technology id: 1, name: "Rails", created_at: "2024-03-11 22:29:59.370454000 +0000", updated_at: "2024-03-11 22:29:59.370454000 +0000">, #<Technology id: 2, name: "Angular", created_at: "2024-03-11 22:30:44.728194000 +0000", updated_at: "2024-03-11 22:30:44.728194000 +0000">]>
# (byebug)
