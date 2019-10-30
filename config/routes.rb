Rails.application.routes.draw do

  root to:'items#index'
  devise_for :users

  resources :notifications, only: :index

  resources :items do
    post :apply, on: :member
    post :cancel, on: :member
    post :approve, on: :member
    post :reject, on: :member
    post :complete, on: :member
  end

  resources :users do
    get :applying, on: :member
    get :waiting, on: :member
    get :lending, on: :member
    get :borrowing, on: :member
    get :notifications, on: :member
  end


end
