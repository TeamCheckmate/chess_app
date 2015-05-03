Rails.application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "welcome/index" => 'welcome#index'
  get "welcome/about" => 'welcome#about'
  # get "games/:id" => 'game#show'
  root to: 'welcome#index'

  resources :games, :only => [:new, :create, :show, :update]
  resources :welcome, :only => [:index, :about]
  resources :pieces, :only => [:show, :update, :destroy, :edit]
end
