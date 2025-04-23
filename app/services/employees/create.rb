class Employees::Create
  def initialize(data_params, project, technology_name)
    @data_params = data_params
    @project = project
    @technologies_name = technology_name
  end

  def call
    create_employee
    @employee
  end

  def create_employee
    if @project
      project = Project.find_by(title: @project)
      @data_params[:project] = project
    end

    @employee = Employee.create(@data_params)

    technologies = Technology.where(name: @technologies_name)
    @employee.technologies << technologies
  end
end
