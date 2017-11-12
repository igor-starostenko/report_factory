# frozen_string_literal: true

# Main abstract class that owns common behavior
class ApplicationController < ActionController::API
  private

  def attributes(type, nested = [])
    fetch_params(type).dig(*([:attributes] + nested))
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
