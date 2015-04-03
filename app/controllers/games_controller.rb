class GamesController < ApplicationController
	before_action :authenticate_user!
	def new
		@game = Game.new
	end

	def create
		@game = Game.create(:white_player_id => current_user.id)
	end
	
	def show 
		
	end

	private

	def game_params
		params.require(:game).permit(:white_player_id, :black_player_id)
	end

end
