GraphiQL::Rails.config.headers['X-API-KEY'] = -> (_context) { ENV['X_API_KEY'] }
