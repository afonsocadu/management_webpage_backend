class Projects::Index
  def call
    projects = Project.includes(:employees)

    projects_data = projects.map do |project|
      {
        id: project.id,
        title: project.title,
        associated_employees: project.employees.pluck(:user_name),
        employees_available: Employee.can_be_associated_to_project(project.title).pluck(:user_name),
        technologies: project.technologies.pluck(:name)
      }
    end

    projects_data
  end
end
