class ProjectsController < ApplicationController
  def index
    # render json: Project.all
  end

  def show
    # render json: @project
  end

  def create
    # if @project.present?
    #   render nothing: true, status: :conflict
    # else
    #   @project = Project.new
    #   @project.assign_attributes(@json['project']
    #   if @project.save
    #     render json: @project
    #   else
    #      render nothing: true, status: :bad_request
    #   end
    # end
  end

  def update
    # TODO: add logic
  end
end
