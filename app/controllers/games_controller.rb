class GamesController < ApplicationController
	before_action :authenticate_user!
	def new
		@game = Game.new
	end

	def create
		@game = Game.create(:white_player_id => current_user.id)
	end
	
	def show 
		@game = Game.find(params[:id])
		@pieces = @game.pieces
	end

	def select
		@game = Game.find(params[:id])
    @pieces = @game.pieces
    @piece = Piece.find(params[:piece_id])
    @piece_id = params[:piece_id]
    @x_coord = params[:x_coord]
    @y_coord = params[:y_coord]
	end

	private

	def game_params
		params.require(:game).permit(:white_player_id, :black_player_id)
	end

end
