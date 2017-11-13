# frozen_string_literal: true

# Classes are lazy loaded in the development environment
if Rails.env.development?
  %w[user tester admin].each do |c|
    require_dependency File.join('app', 'models', "#{c}.rb")
  end
end
