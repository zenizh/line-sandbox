Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :account, only: :show
  resources :messages, only: :create
  resources :sessions, only: :new

  get :callback, to: 'sessions#create'
end
