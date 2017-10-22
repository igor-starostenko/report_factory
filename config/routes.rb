Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
   scope '/api' do
    scope '/v1' do
      scope '/reports' do
        get '/' => 'reports#index'
        post '/' => 'reports#create'
        get '/:id' => 'reports#show'
      end
    end
  end 
end
