# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  before do
    Project.create(title: 'Indirect')
  end

  context 'when provided project id does not exist' do
    it 'does not destroy the project' do
      delete :destroy, params: { id: '2' }

      expect(Project.all.size).to be(1)
    end

    it 'returns status code 404' do
      delete :destroy, params: { id: '2' }

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when provided project id does exist' do
    it 'returns status code 200' do
      delete :destroy, params: { id: '1' }

      expect(response).to have_http_status(:ok)
    end

    it 'destroys the project' do
      delete :destroy, params: { id: '1' }

      expect(Employee.all.size).to eq(0)
    end
  end

  context 'when deletion fails' do
    it 'returns an error response' do
      allow(Project)
        .to receive(:find)
              .and_return(instance_double(Project, destroy: false,
                                          errors: instance_double(ActiveModel::Errors, full_messages: [])))

      delete :destroy, params: { id: 1 }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
