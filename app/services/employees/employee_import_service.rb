# app/services/employees/employees_import_service.rb

require 'roo'

# This service is responsible for importing employee data from a file.
class Employees::EmployeeImportService
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    spreadsheet = Roo::Spreadsheet.open(@file.path)

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
  end
end
