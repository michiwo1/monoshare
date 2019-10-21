Rails.application.routes.draw do


  root to:'items#index'
  devise_for :users


  resources :items do
    resource :rentals, only: [:create, :destroy]
    post :approve, on: :member
    post :reject, on: :member
  end

  resources :users do
    get :applying, on: :member 
    get :waiting, on: :member
    get :lending, on: :member
    get :borrow, on: :member
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
