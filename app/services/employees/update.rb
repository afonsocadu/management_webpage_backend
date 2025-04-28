# frozen_string_literal: true

# This service is responsible for updating the employee's information.
class Employees::Update
  # This service is responsible for updating the employee's information.
  # @param technologies [Array] The technologies associated with the employee.
  # @param projects [String] The project associated with the employee.
  # @param data_to_update [Hash] The data to be updated for the employee.
  def initialize(technologies, projects, data_to_update)
    @technologies = technologies
    @projects = projects
    @data_to_update = data_to_update
  end

  def call
    update_employee
  end

  private

  def update_employee
    if @technologies
      technologies = @technologies.filter_map do |name|
        Technology.find_by(name: name)
      end

      @data_to_update[:technologies] = technologies
    end

    if @projects
      project = Project.find_by(title: @projects)

      @data_to_update[:project] = project
    end

    @data_to_update
  end
end
