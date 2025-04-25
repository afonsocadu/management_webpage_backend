# app/jobs/employees/import_file_job.rb
module Employees
  class ImportFileJob < ApplicationJob
    queue_as :default

    def perform(file_path)
      spreadsheet = Roo::Spreadsheet.open(file_path)

      header = spreadsheet.row(1).map(&:to_s)
      (2..spreadsheet.last_row).each do |index|
        row = header.zip(spreadsheet.row(index)).to_h

        ActiveRecord::Base.transaction do
          employee = Employee.create!(
            user_name: row['user_name'],
            project_id: row['project_id']
          )

          technologies_name = row['technology_name'].split(';').map(&:strip)

          technologies = technologies_name.map { |name| Technology.find_or_create_by(name: name) }

          employee.technologies << technologies
        end
      end

      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
