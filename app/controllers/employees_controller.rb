class EmployeesController < ApplicationController
  def index
    employees = Employee.left_joins(:project).select(:id, :user_name, :title, :technologies)

    render status: 200,
           json: employees
  end

  def destroy
    employee = Employee.find(params[:id])

    if employee
      employee.destroy
      render json: { message: 'Employee deleted succesfully!' }
    else
      render json: { error: 'Employee not found' },  status: :unprocessable_entity
    end
  end

  def update
    employee = Employee.find(params[:id])
    title = params.require(:project)

    if title
      project_id = Project.find_by(title: title).id
    end

    if employee && project_id
      employee.update(user_name: params[:user_name], project_id: project_id)
      render status: :ok, json: employee
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not updated!' }

    end
  end

  def create
    title = params[:project]
    user_name = params[:user_name]

    if title && user_name
      project = Project.find_by(title: title)

      employee = Employee.new(
        user_name: user_name,
        project_id: project.id,
      )

      if employee.save
        render status: :ok, json: employee
      else
        render status: :unprocessable_entity, json: { error: 'Employee was not created!' }
      end
    end
  end
end
