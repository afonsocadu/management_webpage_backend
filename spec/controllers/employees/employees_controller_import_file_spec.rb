require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  include ActiveJob::TestHelper

  describe 'POST #import_file' do
    around do |example|
      perform_enqueued_jobs do
        example.run
      end
    end

    let(:file) { fixture_file_upload(file_fixture('employees.xlsx'), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

    before do
      create(:technology, name: 'Ruby')
      create(:technology, name: 'Java')
      create(:technology, name: 'Python')
      create(:technology, name: 'Angular')

      # I decided not mocking the job to ensure the full flow is working correctly
    end

    it 'return status 200' do
      post :import_file, params: { file: file }

      expect(response).to have_http_status(202)
    end

    it 'expects to create employees' do
      post :import_file, params: { file: file }

      expect(Employee.count).to eq(2)
    end

    it 'imports employees from a excel file' do
      post :import_file, params: { file: file }

      imported_usernames = Employee.pluck(:user_name)

      expect(imported_usernames).to include('User 01', 'User 02')
    end

    it 'import technologies from a excel file' do
      post :import_file, params: { file: file }

      employee_01 = Employee.find_by(user_name: 'User 01')
      employee_02 = Employee.find_by(user_name: 'User 02')

      expect(employee_01.technologies.pluck(:name)).to include('Ruby', 'Java')
      expect(employee_02.technologies.pluck(:name)).to include('Angular', 'Python')
    end

    it 'enqueues the import job with the correct path' do
      expect(Employees::ImportFileJob).to receive(:perform_later).with(a_string_including('employees.xlsx'))

      post :import_file, params: { file: file }
    end
  end
end
