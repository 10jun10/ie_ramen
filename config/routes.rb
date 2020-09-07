Rails.application.routes.draw do
  
  get "favorites", to: "favorites#index"
  post "favorites/:noodle_id/create" => "favorites#create"
  delete "favorites/:noodle_id/destroy" => "favorites#destroy"

  get :login, to: 'sessions#new'
  post :login, to: 'sessions#create'
  delete :logout, to: 'sessions#destroy'
  
  get :signup, to:'users#new'
  resources :users
  resources :noodles
  resources :notifications, only: :index
  resources :comments, only: [:create, :destroy]
  # root 'noodles#index'
  root 'static_pages#top'
  get :about, to: 'static_pages#about'
  get :top, to: 'static_pages#top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
