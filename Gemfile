# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.12.0'
# Serve API with GraphQL
gem 'graphql-preload' # includes the graphql gem
# Build JSON APIs with ease
gem 'jbuilder'
gem 'jsonapi-rails'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Provides support for CORS for web applications
gem 'rack-cors', require: 'rack/cors'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Pagination for api
gem 'api-pagination'
gem 'will_paginate'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution
  # and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'coffee-rails' # Dependency for GraphiQL
  gem 'factory_bot_rails'
  gem 'graphiql-rails'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'sass-rails' # Dependency for GraphiQL
  gem 'simplecov', '~> 0.16.1'
  gem 'uglifier' # Dependency for GraphiQL
  # Spring speeds up development by keeping your application running
  # in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
