Rails.application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get "welcome/index" => 'welcome#index'
  get "welcome/about" => 'welcome#about'
  patch 'check_pawn_promotion/:id', :to => "games#check_pawn_promotion", :as => "pawn_promotion"
  root to: 'welcome#index'

  resources :games, :only => [:new, :create, :show, :update ]
  patch "games/:id/join" => 'games#join', :as => 'game_join'
  patch "welcome/quick_play" => 'welcome#quick_play', :as => 'welcome_quick_play'

  get "games/:id/render_chess_board" => 'games#render_chess_board', :as => "game_render_chess_board"

  resources :welcome, :only => [:index, :about]
  resources :pieces, :only => [:show, :update, :destroy, :edit] do 
  	patch "change_piece_type/:piece_type", :to => "pieces#change_piece_type"
  end
end
