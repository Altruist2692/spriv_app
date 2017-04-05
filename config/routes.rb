Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "users#index"
  get 'users/login' => 'authentications#login', as: :login
  get "callback_handler" => 'home#callback_handler'
  resources :users
  get 'users/:id/invite' => 'users#invite', as: :invite_user
  post 'users/add_login' => 'authentications#add_login', as: :add_login
  post 'users/add_verification' => 'authentications#add_verification', as: :add_verification
  post 'users/add_two_way_sms_verification' => 'authentications#add_two_way_sms_verification', as: :add_two_way_sms_verification
  post 'users/add_totp' => 'authentications#add_totp', as: :add_totp
end
