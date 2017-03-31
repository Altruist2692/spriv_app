Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"
  resources :users
  get 'users/:id/invite' => 'users#invite', as: :invite_user
end
