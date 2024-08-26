class Employees::Index
  def call
    employees = Employee.left_joins(:project).select(:id, :user_name, :title)

    employees_data = employees.map do |employee|
      {
        id: employee.id,
        user_name: employee.user_name,
        title: employee.title,
        technologies: employee.technologies.pluck(:name)
      }
    end

    employees_data
  end
end
