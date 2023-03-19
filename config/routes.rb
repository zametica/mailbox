Rails.application.routes.draw do
  devise_for :users,
             skip: [:sessions],
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    post 'sign_in', to: 'devise/session#create', as: :session
    delete 'sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  namespace :api do
    resources :mails, only: :index
  end
  resources :mails, only: :index

  root 'mails#index'
end
