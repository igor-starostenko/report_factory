# frozen_string_literal: true

# rubocop:disable BlockLength

Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
  post '/graphql', to: 'graphql#execute'
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
  scope '/api' do
    scope '/v1' do
      scope '/cache' do
        get '/clear' => 'application#cache_evict'
      end
      get '/user' => 'users#auth'
      scope '/users' do
        get '/' => 'users#index'
        post '/login' => 'users#login'
        post '/create' => 'users#create'
        scope '/:id' do
          put '/' => 'users#update'
          get '/' => 'users#show'
          delete '/' => 'users#destroy'
          scope '/reports' do
            get '/' => 'user_reports#index'
            get '/rspec' => 'user_rspec_reports#index'
          end
        end
      end
      scope '/projects' do
        get '/' => 'projects#index'
        post '/' => 'projects#create'
        scope '/:project_name' do
          get '/' => 'projects#show'
          put '/' => 'projects#update'
          delete '/' => 'projects#destroy'
          scope '/reports' do
            get '/' => 'project_reports#index'
            scope '/mocha' do
              get '/' => 'project_mocha_reports#index'
              post '/' => 'project_mocha_reports#create'
              get '/:id' => 'project_mocha_reports#show'
            end
            scope '/rspec' do
              get '/' => 'project_rspec_reports#index'
              post '/' => 'project_rspec_reports#create'
              get '/:id' => 'project_rspec_reports#show'
            end
          end
          scope '/scenarios' do
            get '/' => 'project_scenarios#index'
          end
        end
      end
      scope '/reports' do
        get '/' => 'reports#index'
        scope '/rspec' do
          get '/' => 'rspec_reports#index'
          get '/:id' => 'rspec_reports#show'
        end
        get '/:id' => 'reports#show'
      end
      scope '/scenarios' do
        get '/' => 'scenarios#index'
      end
    end
  end
end

# rubocop:enable BlockLength
