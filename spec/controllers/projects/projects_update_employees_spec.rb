# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:technologies) { [create(:technology, name: 'Rails')] }

  before do
    create(:project, title: 'Project X', technologies: technologies)
    create(:employee, user_name: 'Amaral', technologies: technologies)
  end

  context 'without mandatory parameters' do
    it 'returns status code 400' do
      put :update_employees, params: { updated_data: { project_id: 1 } }

      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when do not find project id' do
    project_nonexistent = { project_id: 100, updated_data: { title: 'INAO', employees: []  } }

    it 'returns status code 404' do
      put :update_employees, params: project_nonexistent, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid project params' do
    let(:technologies) { [create(:technology, name: 'Python')] }
    before do
      create(:employee, user_name: 'Cadu', technologies: technologies)
      create(:project, title: 'Project Y', technologies: technologies)
    end

    context 'When the user lacks the required technologies for the project' do
      let(:technologies_employee) { create(:technology, name: 'React') }
      let(:employee_wrong_technologies) { { project_id: 2, updated_data: { title: 'Project Y', employees: ['Cardador'] } } }

      before do
        create(:employee, user_name: 'Cardador', technologies: [technologies_employee] )
      end

      it 'returns the not updated employee' do
        put :update_employees, params: employee_wrong_technologies, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response['updated_employees']).to eq([])
        expect(json_response['employees_not_updated'][0]['user_name']).to eq('Cardador')
      end
    end

    let(:project_to_update) { { project_id: 2, updated_data: { title: 'Project Y', technologies: ['Python'], employees: ['Cadu'] } } }

    it 'returns 200' do
      put :update_employees, params: project_to_update, as: :json

      expect(response).to have_http_status(:ok)
    end

    it 'returns the updated employee' do
      put :update_employees, params: project_to_update, as: :json

      json_response = JSON.parse(response.body)

      expect(json_response['updated_employees'][0]['user_name']).to eq('Cadu')
    end

    it 'updates the project title' do
      put :update_employees, params: project_to_update, as: :json

      updated_project = Project.find(project_to_update[:project_id])
      expect(updated_project.title).to eq(project_to_update[:updated_data][:title])
    end
  end
end
