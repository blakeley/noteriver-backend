Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show, :index]
      resources :sessions, only: [:create]
      resources :scores, only: [:create, :show, :index]
    end
  end
end
