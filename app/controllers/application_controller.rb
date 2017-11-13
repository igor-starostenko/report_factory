# frozen_string_literal: true

# Main abstract class that owns common behavior
class ApplicationController < ActionController::API
  before_action :require_log_in, except: %i[login]

  private

  def attributes(type, *nested)
    fetch_params(type).dig(:attributes, *nested)
  end

  def fetch_params(type)
    type_attrs = self.class.const_get("#{type.to_s.upcase}_ATTRIBUTES")
    params.require(:data).permit(:type, attributes: type_attrs)
  end

  def render_not_found(type)
    error_message = "#{type.capitalize} Not Found"
    render json: { message: error_message }, status: :not_found
  end

  def require_log_in
    authenticate_api_key || render_unauthorized
  end

  def require_admin
    return if @auth_user.type == 'Admin'
    render_unauthorized
  end

  def authenticate_api_key
    api_key = request.headers['X-Api-Key']
    @auth_user = User.find_by(api_key: api_key)
  end

  def render_unauthorized
    render json: { message: 'Not authorized' }, status: 401
  end
end
