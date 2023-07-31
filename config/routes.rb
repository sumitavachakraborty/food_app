# frozen_string_literal: true
# rubocop:disable all
Rails.application.routes.draw do
  resources :users, except: %i[new create] do
    post 'location', to: 'users#location'
  end
  resources :categories
  root 'pages#home'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  post 'makeadmin', to: 'users#makeadmin'
  post 'markread', to: 'resturants#markread'
  post 'count', to: 'resturants#count'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'login_verify', to: 'sessions#verify'
  delete 'logout', to: 'sessions#destroy'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  resources :resturants do
    resources :foods, except: [:show]
    resources :orders, except: [:show]
    resources :reviews
    post 'approve', to: 'reviews#approve'
    get '/gallery', to: 'resturants#gallery'
    resources :book_tables
    get 'search', on: :collection
    get 'filter_locations', on: :collection
    post 'image', to: 'resturants#attach_image'
  end
  post 'image', to: 'users#image'
  # match '*unmatched', to: 'application#not_found_method', via: :all, constraints: lambda { |req|
  #   !req.path.match(%r{\A/rails/active_storage/})
  # }
end

# rubocop:enable all
