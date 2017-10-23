Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
   scope '/api' do
    scope '/v1' do
      scope '/projects' do
        get '/' => 'projects#index'
        post '/' => 'projects#create'
        scope '/:project_name' do
          get '/' => 'projects#show'
          put '/' => 'projects#update'
          scope '/reports' do
            get '/' => 'reports#index'
            scope '/rspec' do
              get '/' => 'rspec_reports#index'
              post '/' => 'rspec_reports#create'
              get '/:id' => 'rspec_reports#show'
            end
          end
        end
      end
    end
  end 
end
