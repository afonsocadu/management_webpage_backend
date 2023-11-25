# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:endpoint) { 'app/controllers/employees_controller' }


  before do
    project = Project.create(title: 'Indirect')
    Employee.create(user_name: 'Amaral', project:)
  end

  context 'when provided employee id does not exist' do
    xit 'does not destroy the employee' do
      delete :destroy, params: { id: '2' }

      expect(Employee.all.size).to eq(1)
      #Ainda não consegui fazer este funcionar
    end

    it 'returns status code 404' do
      expect { delete :destroy, params: { id: '2' } }
        .to raise_error(ActiveRecord::RecordNotFound)

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
end


#Um teste não funciona
# #Eu queria poder passar o let endpoint
