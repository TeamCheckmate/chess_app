class GamesController < ApplicationController
	before_action :authenticate_user!
	def new
		@game = Game.new
	end

	def create
		@game = Game.create(:white_player_id => current_user.id)
		redirect_to game_path(@game)
	end
	
	def show 
		@game = Game.find(params[:id])
		@pieces = @game.pieces
	end

	private

	def game_params
		params.require(:game).permit(:white_player_id, :black_player_id)
	end

end
