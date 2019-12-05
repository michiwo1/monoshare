Rails.application.routes.draw do


  root'items#index'

  devise_for :users

  resources :search, only: :index
  resources :notifications, only: :index


  resources :users do
    get :applying, on: :member
    get :waiting, on: :member
    get :lending, on: :member
    get :borrowing, on: :member
    get :notifications, on: :member
    get :favorite, on: :member
  end

  resources :items do
    post :apply, on: :member
    post :cancel, on: :member
    post :approve, on: :member
    post :reject, on: :member
    post :complete, on: :member
    resource :favorites, only: [:create,:destroy]
    resource :comments, only: [:create,:destroy]
  end

  get '(*unmatched_route)' => redirect('/')
end
