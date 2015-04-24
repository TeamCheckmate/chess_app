class GamesController < ApplicationController
	before_action :authenticate_user!
	protect_from_forgery
  	skip_before_filter  :verify_authenticity_token
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

	def update
		@game = Game.find(params[:id])
		@game.update_attributes(:black_player_id => current_user.id)
		redirect_to game_path(@game)
	end

	private

	def game_params
		params.require(:game).permit(:white_player_id, :black_player_id)
	end

end
