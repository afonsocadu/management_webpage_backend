class TechnologiesController < ApplicationController

  # Returns a list of technologies
  def index
    technologies = Technology.all

    render status: 200,
          json: technologies
  end

  # Deletes a tecnology based on the provided 'id'
  def destroy
    technology = Technology.find(params[:id])

    if technology.destroy
      render json: { message: 'Technology deleted successfully!' }
    else
      render json: { error: 'An error occurred when trying to delete the technology', details: technology.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Updates a tecnology based on the provided name

  def update
    technology = Technology.find(params[:id])

    if technology.update(name: params[:name])
      render status: :ok, json: technology
    else
      render status: :unprocessable_entity, json: { error: technology.errors.full_messages.to_sentence }
    end
  end

  # Creates a new technology based on the provided parameter,

  def create
    name = params.require(:name)

    technology = Technology.new(
      name: name
    )

    if technology.save
      render status: :ok, json: technology
    else
      render status: :unprocessable_entity, json: { error: technology.errors.full_messages.to_sentence }
    end
  end
end
