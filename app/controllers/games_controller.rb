class GamesController < ApplicationController
	before_action :authenticate_user!
	protect_from_forgery
  	skip_before_filter  :verify_authenticity_token
	def new
		@game = Game.new
	end

	def create
		@game = Game.create(game_params)
		redirect_to game_path(@game)
	end
	
	def show 
		@game = Game.find(params[:id])
		@pieces = @game.pieces
	end

	def check_pawn_promotion
		@game = Game.find(params[:id])
		pawns = @game.pieces.where(:piece_type => 'Pawn')

		if !pawns.empty?
			pawn_id = -1
			pawns.each do |pawn|
				if pawn.y_coord == 0 || pawn.y_coord == 7
					pawn_id = pawn.id
				end
			end
			
			if pawn_id == -1
				render :nothing
			else
				render :json => {:pawn_id => pawn_id, :message => "pawn promoted"}, :status => :partial_content
			end
		else
			render :nothing
		end


	end

	def update
		@game = Game.find(params[:id])
		@game.update_attributes(:black_player_id => current_user.id)
		redirect_to game_path(@game)
	end

	private

	def game_params
		params[:game][:white_player_id] = current_user.id
		params[:turn] = "white"
		params.require(:game).permit(:white_player_id , :black_player_id, :title, :turn)
	end

end
