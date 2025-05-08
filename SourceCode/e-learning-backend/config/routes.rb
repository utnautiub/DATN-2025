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
      resources :schools, only: [:index, :show, :create, :update, :destroy]
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
      
      # Cụm 1: Buildings, Rooms, Equipment, Equipment Reports
      resources :buildings, only: [:index, :create, :update, :destroy]
      resources :rooms, only: [:index, :create, :update, :destroy]
      resources :room_equipments, only: [:index, :create, :update, :destroy]
      resources :equipment_items, only: [:destroy]
      resources :equipment_reports, only: [:index, :create, :update, :destroy]

      # Cụm 2: Departments, Majors, Training Programs, Training Program Subjects, Subjects
      resources :departments, only: [:index, :create, :update, :destroy]
      resources :majors, only: [:index, :create, :update, :destroy]
      resources :training_programs, only: [:index, :create, :update, :destroy]
      resources :training_program_subjects, only: [:index, :create, :destroy]
      resources :subjects, only: [:index, :create, :update, :destroy]

      # Cụm 3: Additional Routes
      resources :user_groups, only: [:index, :create, :update, :destroy]
      resources :subjects, only: [:index, :create, :update, :destroy]
      resources :teachers, only: [:index]
    end
  end

end
