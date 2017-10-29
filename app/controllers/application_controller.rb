# frozen_string_literal: true

# Main abstract class that owns common behavior
class ApplicationController < ActionController::API
  private

  def set_project
    @project = Project.find_by(project_name: project_name)
    return render_not_found(:project) unless @project
  end

  def project_name
    params.fetch(:project_name).split('_').map(&:capitalize).join(' ')
  end

  def attributes(type)
    fetch_params(type).fetch(:attributes, {})
  end

  def fetch_params(type)
    type_attrs = self.class.const_get("#{type.to_s.upcase}_ATTRIBUTES")
    params.require(:data).permit(:type, attributes: type_attrs)
  end

  def render_not_found(type)
    error_message = "#{type.capitalize} Not Found"
    render json: { message: error_message }, status: :not_found
  end
end
