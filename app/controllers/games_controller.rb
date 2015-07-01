class GamesController < ApplicationController
	before_action :authenticate_user!
	before_action :current_game, :only => [:show, :check_pawn_promotion, :join, :render_chess_board]
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
		@pieces = @game.pieces
	end

	def check_pawn_promotion
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
				render :json => {:pawn_id => pawn_id }
			end
		else
			render :nothing
		end


	end

	def join
		if @game.not_white_player?(current_user)
			@game.update_attributes(:black_player => current_user )
			flash[:notice] = "You joined the game: #{@game.title}"
			redirect_to game_path(@game), action: 'get'
		else
			flash[:alert] = "Cannot join the game, you are already in this game."
			redirect_to root_path
		end		
	end

	def render_chess_board
		render :partial => "chess_board",
				:locals => { game: current_game }
	end

	private
	def current_game
		@game ||= Game.find(params[:id])
	end

	def game_params
		params[:game][:white_player_id] = current_user.id
		params.require(:game).permit(:white_player_id , :black_player_id, :title)
	end

end
