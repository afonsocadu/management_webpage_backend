class EmployeesController < ApplicationController
  def index
    employees = Employee.left_joins(:project).select(:id, :user_name, :title, :technologies)

    render status: 200,
           json: employees
  end

  def destroy
    begin
      employee = Employee.find(params[:id])

      if employee.destroy
        render json: { message: 'Employee deleted successfully!' }
      else
        render json: { error: 'An error occurred when trying to delete the employee', details: employee.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Employee not found' }, status: :not_found
    end
  end


  def update
    begin
      employee = Employee.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Employee not found' }, status: :not_found
      return
    end

    title = params.require(:project)

    if title
      project_id = Project.find_by(title: title)&.id
    end

    unless project_id
      render status: :unprocessable_entity,
             json: 'The project does not exist'
    end

    if employee.update(user_name: params[:user_name], project_id: project_id)
      render status: :ok, json: employee
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not updated!' }
    end
  end


  def create
    begin
    title = params[:project]
    user_name = params[:user_name]
    unless title && user_name
      render status: :no_content, json: { error: 'Both project title and user name are required' }
      return
    end

      project = Project.find_by(title: title)
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Employee not found' }, status: :not_found
      end

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
