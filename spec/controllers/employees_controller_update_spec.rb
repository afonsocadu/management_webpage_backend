# frozen_string_literal: true
require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do

  before do
    create_list(:project, 3)
    employee = Employee.create(user_name: 'Teresa', project_id: 1)
  end

  context 'without employee params' do

    it 'returns status code 400' do
      expect { put :update, params: { id: 1 } }
        .to raise_error(ActionController::ParameterMissing)
    end

    it 'does not update the record' do
      expect {
        put :update, params: { id: 1, employee: { user_name: 'NovoNome' } }
      }.to raise_error(ActionController::ParameterMissing)
    end
    #Como sempre, um erro é gerado, fica difícil de testar...
  end

  context 'When do not find employee id' do
    employee_nonexistent = { id: 100, employee: { user_name: 'Cadu', project: 'Project 1' } }

    it 'returns status code 400' do

      expect { put :update, params: employee_nonexistent }
        .to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  context 'with valid workspace params' do
    employee_to_update = { id: 1, user_name: 'Amaral', project: 'Project 2' }

    xit 'returns 200' do
      put :update, params: employee_to_update

      expect(response).to have_http_status(:ok)
      #Não mostra os parâmetros
    end

    it 'returns the updated employee' do
      put :update, params: employee_to_update, as: :json

      expect(employee.user_name).to eq('Amaral')
      expect(employee.project).to eq('Project 2')
    end
  end
end
