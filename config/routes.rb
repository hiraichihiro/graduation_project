Rails.application.routes.draw do
  get "wishes/new"
  get "wishes/create"
  root "static_pages#top"
  # ユーザー登録用
  get "signup", to: "users#new"
  post "users", to: "users#create"

  # ゲストログイン用を追加
  post "users/guest_sign_in", to: "users#guest_sign_in"

  # ログイン・ログアウト用
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # 叶えたいことの作成・保存
  resources :wishes, only: [:new, :create]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
