Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'login' => 'login#login'
  get 'login/onetimetoken' => 'login#onetimetoken'
  put 'login/resetpassword' => 'login#resetpassword'

  resources :posts, only: [:index, :show, :create, :update] do
    get 'coordinates', on: :collection
  end

  resources :users, only: [:show, :create]
end
