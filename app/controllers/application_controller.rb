# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def set_project
    @project = Project.find_by(project_name: project_name)
    return render_not_found(:project) unless @project
  end

  def project_name
    params.fetch(:project_name).split('_').map(&:capitalize).join(' ')
  end

  def render_not_found(type)
    error_message = "#{type.capitalize} Not Found"
    render json: { message: error_message }, status: :not_found
  end
end
