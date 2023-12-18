# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:endpoint) { 'app/controllers/employees_controller' }

  before do
    project = Project.create(title: 'Indirect')
    Employee.create(user_name: 'Amaral', project:)
  end

  context 'when provided employee id does not exist' do
    it 'does not destroy the employee' do
      expect do
        delete :destroy, params: { id: '2' }
      end.not_to change(Employee, :count)
    end

    it 'returns status code 404' do
      delete :destroy, params: { id: '2' }

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when provided employee id does exist' do
    it 'returns status code 200' do
      delete :destroy, params: { id: '1' }

      expect(response).to have_http_status(:ok)
    end

    it 'destroys the workspace' do
      delete :destroy, params: { id: '1' }

      expect(Employee.all.size).to eq(0)
    end
  end

  context 'when deletion fails' do
    it 'returns an error response' do
      allow(Employee)
        .to receive(:find)
        .and_return(instance_double(Employee, destroy: false,
                                              errors: instance_double(ActiveModel::Errors, full_messages: [])))

      delete :destroy, params: { id: 1 }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
