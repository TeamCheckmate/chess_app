Rails.application.routes.draw do
  devise_for :users
  get "welcome/index" => 'welcome#index'
  get "welcome/about" => 'welcome#about'
  root to: 'welcome#index'

  resources :games, :only => [:new, :create, :show, :update]
  resources :welcome, :only => [:index, :about]
end
