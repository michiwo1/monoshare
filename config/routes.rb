Rails.application.routes.draw do

  root'items#index'

  devise_for :users

  resources :notifications, only: :index

  resources :users do
    member do
      get :applying
      get :waiting
      get :lending
      get :borrowing
      get :notifications
      get :favorite
    end
  end

  resources :items do
    member do
      post :apply
      post :cancel
      post :approve
      post :reject
      post :complete
    end
    resource :favorites, only: %i[create destroy]
    resource :comments, only: %i[create destroy]
  end
end
