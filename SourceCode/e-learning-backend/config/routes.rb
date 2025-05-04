Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#create'
      resources :schools, only: [:index, :create, :update, :destroy]
      post '/schools/:school_id/admin_accounts', to: 'users#create_admin_account'
      resources :users, only: [:index, :create, :update, :destroy]
      resources :classes, only: [:index, :create, :update, :destroy]
      resources :courses, only: [:index, :create, :update, :destroy]
      resources :schedules, only: [:index, :create, :update, :destroy] do
        member do
          post 'create_meet_link'
        end
      end
      resources :subject_assignments, only: [:index, :create, :update, :destroy]
      resources :enrollments, only: [:index, :create, :destroy]
    end
  end

end
