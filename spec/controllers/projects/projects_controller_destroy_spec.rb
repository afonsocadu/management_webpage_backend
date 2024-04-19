# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  before do
    create(:project, title: 'Indirect')
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
      technology = create(:technology, name: 'Angular')
      project = create(:project, technologies: [technology], id: 50)

      allow(Project).to receive(:find).with(any_args).and_return(project)
      allow(project).to receive(:destroy).and_return(false)

      delete :destroy, params: { id: 50 }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
