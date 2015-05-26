class WelcomeController < ApplicationController
  def index
    @available_games = Game.where(:black_player_id => nil)

    if current_user
    	@recent_game = Game.where(:white_player_id => current_user.id).last
    end
    @game = Game.new
  end

  def about
  end

def quick_play
	@game = Game.where(:black_player_id => nil).last
	if @game.not_white_player?(current_user)
		@game.update_attributes(:black_player => current_user )
		flash[:notice] = "You joined the game: #{@game.title}"
		redirect_to game_path(@game), action: 'get'
	else
		flash[:alert] = "Sorry, No game is available now. Please check later or create your own game!"
		redirect_to root_path
	end	
end
end
