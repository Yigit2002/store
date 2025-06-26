Rails.application.routes.draw do
  get "users/index"
  get "users/update_balance"
  get "carts/show"
  get "carts/add_to_cart"
  get "carts/remove_from_cart"
  get "carts/checkout"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get "privacy_policy", to: "pages#privacy_policy"
  get 'profile', to: 'users#show_profile', as: 'profile'
  get 'profile/edit', to: 'users#edit_profile', as: 'edit_profile'
  get "admin/cards", to: "cards#admin_index", as: :admin_cards
  patch 'profile/update', to: 'users#update_profile', as: 'update_profile'
  patch '/orders/:id/refund', to: 'orders#refund', as: 'refund_order'

  resource :session
  resources :favorites, only: [:index, :create, :destroy]
  resources :orders, only: [:index, :create]
  resources :seller_orders, only: [:index, :update]
  resources :seller_products do
    member do
      get :update
      get :destroy
    end
  end

  namespace :api do
    namespace :v1 do
      resources :comments, only: [:create, :destroy]
      resources :favorites, only: [:index, :create, :destroy]
      resources :seller_orders, only: [:index, :update]
      resources :unsubscribe, only: [:destroy]
      resources :orders, only: [:index] do
        member do
          patch :cancel
          patch :refund
        end
      end
      resources :order_items, only: [:index], param: :order_id
      resources :addresses, only: [:index, :show, :create, :update, :destroy]
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :registrations, only: [:create]

      resources :seller_products, only: [:index, :create, :update, :destroy] do
        member do
          get :edit
        end
      end

      resources :cards, only: [:index, :show, :create, :destroy] do
        member do
          patch :update_balance
        end
      end

      resources :users, only: [:index] do
        member do
          patch :update_balance
        end
      end
      get 'users/show_profile', to: 'users#show_profile'
      patch 'users/update_profile', to: 'users#update_profile'
      
      resource :cart, only: [:show] do
        member do
          patch :update_quantity
          post :add_to_cart
          delete :remove_from_cart
          delete :clear_cart
          post :checkout
        end
      end

      resources :products do
        resources :subscribers, only: [:create]
      end
    end
  end


  resources :seller_products, only: [:index, :show, :edit, :update, :destroy] do
    collection do
      get :my_products, action: :index
    end 
  end
  
  resource :cart, only: [:show] do
    post :add_to_cart, as: :add_to_cart
    post :checkout, to: "carts#checkout"
  end

  resources :orders, only: [:index] do
    member do
      patch :cancel
    end
  end

  resources :carts, only: [] do
    member do
      delete :remove_from_cart
      patch :update_quantity
    end
  end

  delete "cart/remove_from_cart/:id", to: "carts#remove_from_cart", as: :remove_from_cart

  resources :users, only: [:index] do
    member do
      patch :update_balance
    end
  end

  resources :cards, only: [:index, :new, :create, :destroy] do 
    member do
      get :edit_balance
      patch :update_balance
    end
  end

  resources :products, only: [:index, :new, :create, :show, :destroy] do

  end

  resources :products do
    member do
      post 'select_seller'
    end
  end

  resources :categories, only: [:index, :new, :create]
  
  delete :clear_cart, to: "carts#clear_cart"
  resource :registration, only: %i[new create]
  resource :unsubscribe, only: [ :show ]
  resources :passwords, param: :token
  resources :addresses
  resources :products do
  resources :comments, only: [:create, :destroy]
  resources :subscribers, only: [ :create ]
  resources :products, only: [:index, :new, :create]
  end 
  root "products#index"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  delete "session", to: "sessions#destroy"
  # get "/products", to: "products#index"
  # get "/products/new" to: "products#new"pm

  # post "/products", to: "products#create"

  # get "products:id", to: "products#show"
  # get "/products/:id/edit", to: "products#edit"

  # patch "/products/:id", to: "products#update"
  # put "/products/:id", to: "products#update"
  # delete "/products/:id", to: "products#destroy"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
