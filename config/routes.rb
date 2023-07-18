# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, except: [:new] do
    post 'location', to: 'users#location'
  end
  resources :categories
  root 'pages#home'
  get 'signup', to: 'users#new'
  post 'makeadmin', to: 'users#makeadmin'
  post 'markread', to: 'resturants#markread'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'login_verify', to: 'sessions#verify'
  delete 'logout', to: 'sessions#destroy'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  resources :resturants do
    resources :foods, except: [:show]
    resources :orders
    resources :reviews
    post 'approve', to: 'reviews#approve'
    get '/gallery', to: 'resturants#gallery'
    resources :book_tables
    collection do
      get 'search'
      get 'filter_locations'
    end
    post 'image', to: 'resturants#attach_image'
  end
  post 'image', to: 'users#image'
end
