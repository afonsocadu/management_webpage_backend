class EmployeesController < ApplicationController

  # Returns a list of employees with specific information
  def index
    employees_data = Employees::Index.new.call

    render status: 200,
           json: employees_data
  end

  # Deletes an employees based on the provided `id`.
  def destroy #Aqui acredito que é muito simples para criar um serviço.
    employee = Employee.find(params[:id])

    if employee.destroy
      render json: { message: 'Employee deleted successfully!' }
    else
      render json: { error: 'An error occurred when trying to delete the employees', details: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Updates the information of an employees based on the provided `id`.
  def update
    data_to_update = params.permit(:user_name)

    data_updated = Employees::Update.new(params[:technology], params[:project], data_to_update).call

    employee = Employee.find(params[:id])

    if employee.update(data_updated)
      render status: :ok, json: employee
    else
      render status: :unprocessable_entity, json: { error: 'Employee was not updated!' }
    end
  end

  # Creates a new employees based on the provided parameters,
  def create
    data_params = { user_name: params.require(:user_name) }
    technology_name = params.require(:technologies)

    employee = Employees::Create.new(data_params, params[:project], technology_name).call

    if employee.save
      render status: :ok, json: {
        employee: employee
      }
    else
      render status: :unprocessable_entity, json: { error: employee.errors.full_messages }
    end
  end

  # Imports a file containing employee data
  def import_file
    uploaded_file = params.require(:file)

    tmp_path = Rails.root.join('tmp', 'uploads', "#{uploaded_file.original_filename}")
    FileUtils.mkdir_p(File.dirname(tmp_path))
    File.binwrite(tmp_path, uploaded_file.read)

    Employees::ImportFileJob.perform_later(tmp_path.to_s)

    head :accepted
  end
end
