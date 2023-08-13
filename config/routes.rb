Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "static#dashboard"
  resources :expense
  get 'people/:id', to: 'static#person'
  get 'users_account', to: 'users_account#index', as:'current_user_account'
  put 'users_account/:borrower_id', to: 'users_account#update_users_account',  as:'update_users_account'
end
