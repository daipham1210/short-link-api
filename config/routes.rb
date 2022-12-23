Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  namespace :api do
    namespace :v1 do
      resources :short_urls, only: [:create]
    end
  end

  get '/:shorten', to: 'redirects#show'
end
