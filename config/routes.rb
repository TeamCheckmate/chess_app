Rails.application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "welcome/index" => 'welcome#index'
  get "welcome/about" => 'welcome#about'
  patch 'check_pawn_promotion/:id', :to => "games#check_pawn_promotion", :as => "pawn_promotion"
  # get "games/:id" => 'game#show'
  root to: 'welcome#index'

  resources :games, :only => [:new, :create, :show, :update]

  resources :welcome, :only => [:index, :about]
  resources :pieces, :only => [:show, :update, :destroy, :edit] do 
  	patch "change_piece_type/:piece_type", :to => "pieces#change_piece_type"
  end
end
