class WelcomeController < ApplicationController
  def index
    @available_games = Game.where(:black_player_id => nil)
    @game = Game.new
  end

  def about
  end
end
