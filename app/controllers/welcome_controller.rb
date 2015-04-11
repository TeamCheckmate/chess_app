class WelcomeController < ApplicationController
  def index
    @available_games = Game.where(:black_player_id => nil)
  end

  def about
  end
end
