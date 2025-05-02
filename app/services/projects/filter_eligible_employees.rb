# frozen_string_literal: true

# This service is responsible for filtering employees based on their technologies
class Projects::FilterEligibleEmployees

  # @param employees_name [Array] List of employee names to be filtered.
  # @param project [Project] The project to which the employees are associated.
  def initialize(employees_name, project)
    @employees_name = employees_name
    @project = project
    @employees = { employee_to_update: [], employees_not_updated: [] }
  end

  def call
    filter_employee
  end

  private

  def filter_employee
    @employees_name.each do |employee_name|
      employee = Employee.find_by(user_name: employee_name)

      if employee_valid?(employee, @project)
        @employees[:employee_to_update] << employee
      else
        @employees[:employees_not_updated] << employee
      end
    end

    @employees
  end

  private

  # Verify if the associated employees has the necessary technology.
  def employee_valid?(employee, project)
    return false if project.nil? || employee.nil?

    project_technologies = project.technologies.pluck(:name)

    employee_technologies = employee.technologies.pluck(:name)

    return employee_technologies.any? { |tech| project_technologies.include?(tech) }
  end
end
