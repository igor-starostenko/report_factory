# frozen_string_literal: true

# Main abstract class that owns common behavior
class ApplicationController < ActionController::API
  before_action :require_log_in, except: %i[cache_evict login]

  def cache_evict
    Rails.cache.clear
    render json: { message: 'Cache has been cleared successfully' }, status: 200
  end

  private

  def attributes(type, *nested)
    fetch_params(type).dig(:attributes, *nested)
  end

  def fetch_params(type)
    type_attrs = self.class.const_get("#{type.to_s.upcase}_ATTRIBUTES")
    params.require(:data).permit(:type, attributes: type_attrs)
  end

  def ensure_in_bounds(records)
    return records unless records.out_of_bounds?

    response.headers['Page'] = records.total_pages
    records.paginate(page: records.total_pages)
  end

  def authenticate_api_key
    api_key = request.headers['X-API-KEY']
    @auth_user = User.find_by(api_key: api_key)
  end

  def require_log_in
    authenticate_api_key || render_unauthorized
  end

  def admin?
    @auth_user.type == 'Admin'
  end

  def require_admin
    admin? || render_unauthorized
  end

  def render_unauthorized
    render json: errors_payload('Not authorized'), status: 401
  end

  def render_not_found(type)
    error_message = "#{type.capitalize} Not Found"
    render json: errors_payload(error_message), status: :not_found
  end

  def errors_payload(*details)
    { errors: details.map { |str| { detail: str } } }
  end
end
