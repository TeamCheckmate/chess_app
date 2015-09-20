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
                @row_letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
                @row_numbers = [1, 2, 3, 4, 5, 6, 7, 8] 
                @white_moves, @black_moves = moves_to_string 
	end

        def moves_to_string
                column_hash = {0 => 'h', 1 => 'g', 2 => 'f', 3 => 'e', 4 => 'd', 5 => 'c', 6 => 'b', 7 => 'a'}
                white_moves = []
                black_moves = []
                @game.moves.each do |move|
                  if move.castle
                    move_str = "Castle"
                  else
                    case move.piece.type
                    when "Pawn"
                      letter = ""
                    when "King"
                      letter = "K"
                    when "Queen"
                      letter = "Q"
                    when "Knight"
                      letter = "N"
                    when "Rook"
                      letter = "R"
                    when "Bishop"
                      letter = "B"
                    end
                  if move.take
                    connect = 'x'
                  else
                    connect = '->'
                  end
                  move_str = letter + column_hash[move.old_x] + (move.old_y + 1).to_s + connect + column_hash[move.x_coord] + (move.y_coord + 1).to_s
                  end
                  if move.piece.color == 'white'
                    white_moves << move_str
                  else
                    black_moves << move_str
                  end
               end
               return white_moves, black_moves
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
				render :nothing => true
			else
				render :json => {:pawn_id => pawn_id }
			end
		else
			render :nothing => true
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
                @white_moves, @black_moves = moves_to_string
		render :json => {
				:chess_board => render_to_string( {
				:partial => "chess_board",
				:locals => { game: current_game,
                                             row_letters: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
                                             row_numbers: [1, 2, 3, 4, 5, 6, 7, 8]
                                  }
				}),
                                :move_list => render_to_string({
                                  :partial => "move_list",
                                  :locals => { white_moves: @white_moves,
                                               black_moves: @black_moves
                                             }
                                })
		}
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
