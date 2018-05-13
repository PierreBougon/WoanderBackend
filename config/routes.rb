Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'ping' => 'application#ping'

  resources :posts, only: [:index, :show]
  resources :users, only: [:show, :create]
end
