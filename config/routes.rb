# frozen_string_literal: true
# rubocop:disable all
Rails.application.routes.draw do
  resources :users,path_names: { new: 'signup', create: 'signup' } do
    post 'location', on: :member
    get 'change_address', on: :member
    get 'admin_login', on: :collection
    post 'check_admin', on: :collection
  end
  resources :categories, except: [:edit, :update]
  root 'pages#home'
  
  resources :sessions, only: [:new,:create], path: "",path_names: {new: 'login', create: 'login'} do
    get 'login_verify', to: 'sessions#verify', on: :collection
    delete 'logout', to: 'sessions#destroy', on: :collection
    get '/auth/google_oauth2/callback', to: 'sessions#omniauth', on: :collection
  end

  resources :resturants do
    resources :foods, except: [:show]
    resources :orders, except: [:show]
    resources :reviews
    post 'approve', to: 'reviews#approve'
    get '/gallery', to: 'resturants#gallery'
    resources :book_tables, except: [:edit, :update]
    get 'search', on: :collection
    get 'filter_locations', on: :collection
    post 'image', to: 'resturants#attach_image'
  end
  post 'image', to: 'users#image'

  post 'makeadmin', to: 'users#makeadmin'
  post 'markread', to: 'resturants#markread'
  post 'count', to: 'resturants#count'
  match '*unmatched', to: 'application#not_found_method', via: :all, constraints: lambda { |req|
    !req.path.match(%r{\A/rails/active_storage/})
  }
end

# rubocop:enable all
