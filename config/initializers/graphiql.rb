# frozen_string_literal: true

if Rails.env.development?
  GraphiQL::Rails.config.headers['X-API-KEY'] = ->(_context) { ENV['X_API_KEY'] }
end
