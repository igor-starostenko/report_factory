# frozen_string_literal: true

# rubocop:disable BlockLength

Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
  scope '/api' do
    scope '/v1' do
      get '/user' => 'users#auth'
      scope '/users' do
        get '/' => 'users#index'
        post '/login' => 'users#login'
        post '/create' => 'users#create'
        scope '/:id' do
          put '/' => 'users#update'
          get '/' => 'users#show'
          delete '/' => 'users#destroy'
          get '/reports' => 'user_reports#index'
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
            scope '/rspec' do
              get '/' => 'project_rspec_reports#index'
              post '/' => 'project_rspec_reports#create'
              get '/:id' => 'project_rspec_reports#show'
            end
          end
        end
      end
      scope '/reports' do
        get '/' => 'reports#index'
        get '/:id' => 'reports#show'
      end
    end
  end
end
