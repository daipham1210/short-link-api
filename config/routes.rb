Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  namespace :api do
    namespace :v1 do
      resources :short_urls, only: %w[index create update destroy] do
        collection do
          get '/check', to: 'short_urls#check_shorten_available'
        end
      end
    end
  end

  get '/:shorten', to: 'redirects#show', as: :short
end
