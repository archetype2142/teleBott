Rails.application.routes.draw do
  devise_for :users
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  mount Sidekiq::Web, at: "/sidekiq"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == "test123" && password == "test123"
  end
  
  root to: "bots#index"
  resources :groups, only: %i[ destroy ]
  resources :bots, only: %i[ index create new update show destroy ]
  resources :messages, only: %i[ edit new update destroy ]
  resources :errors, only: %i[ index destroy ]

  post 'webhook/:id', to: 'webhook#create'

  get 'start_job/:id', to: 'cron_job#start', as: 'start_job'
  get 'stop_job/:id', to: 'cron_job#stop', as: 'stop_job'
end
