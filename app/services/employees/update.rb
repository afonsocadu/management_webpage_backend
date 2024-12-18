class Employees::Update

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
      technologies = @technologies.map { |tech| Technology.find_by(name: tech) }

      @data_to_update[:technologies] = technologies
    end

    if @projects
      project = Project.find_by(title: @projects)

      @data_to_update[:project] = project
    end

    @data_to_update
  end
end
