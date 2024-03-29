Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show, :index, :update]
      resources :sessions, only: [:create]
      resources :scores, only: [:create, :show, :index]
      resources :policies, only: [:show]
    end
  end

  get '(*route)', to: 'pages#index'
end
