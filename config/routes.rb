Rails.application.routes.draw do
  resources :users, except: [:new]
  resources :categories
  root 'pages#home'
  get 'signup' , to: 'users#new'
  post 'makeadmin' , to: 'users#makeadmin'
  post 'markread' , to: 'resturants#markread'
  get 'login' , to: 'sessions#new'
  post 'login' , to: 'sessions#create'
  get 'login_verify', to: 'sessions#verify'
  delete 'logout' , to: 'sessions#destroy'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  resources :resturants do
    resources :foods 
    resources :orders
    resources :reviews
    post 'approve' , to: 'reviews#approve' 
    # post 'new' , to: 'orders#new'
    resources :book_tables
    collection do
      get 'search'
      get 'filter_locations'
    end
  end

  post 'image', to: 'users#image'
end
