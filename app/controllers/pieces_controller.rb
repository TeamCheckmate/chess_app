class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :piece, :only => [:show, :update, :destroy, :edit]
  protect_from_forgery
  skip_before_filter  :verify_authenticity_token
  
  def show
    @game = piece.game_id
  end

  def edit
    @game = piece.game_id
  end

  def update
    game = piece.game

    if !game.black_player.nil? && not_player_turn?
      flash[:alert] = "It's not your turn yet!"
      return render_notifications
    elsif !game.black_player.nil? && picked_wrong_piece_color? 
      flash[:alert] = "Move your pieces only!"
      return render_notifications
    end

    old_x = piece.x_coord
    old_y = piece.y_coord

    if not_moved?(new_x, new_y)
      render :nothing => true
    end

    if piece.move_valid?(new_x, new_y)
      status_code = piece.move_to!(new_x, new_y)
      if piece.color == "white"
        opp_color = "black"
      else
        opp_color = "white"
      end
      if !game.not_stalemate?(opp_color)
        flash[:alert] = "Stalemate!"
        flash[:notice] = "Game ends as a draw!"
      elsif game.check_mate?
        flash[:alert] = "Checkmate!"
        flash[:notice] = "The game ended!"
      elsif status_code == :valid_move
        flash[:alert] = "#{piece.piece_type}: Valid Move!"
      elsif status_code == :reload
        flash[:alert] = "Piece Taken!"
      elsif status_code == :pawn_promote
        return render :json => {:pawn_id => piece.id, :message => "pawn promoted"}, :status => :partial_content
      elsif status_code == :castle
        flash[:alert] = "Castled!"
      else
        flash[:alert] = "#{piece.piece_type}: Invalid move!"
      end
    else
      flash[:alert] = "#{piece.piece_type}: Invalid move!"
    end

    render_notifications
  end

  def change_piece_type
    @piece = Piece.find(params[:piece_id])
    promote_piece_type = params[:piece_type]
    piece_color = @piece.color
    old_piece_type = @piece.piece_type
    promote_piece_image = get_image_name(piece_color, promote_piece_type)
    @piece.update_attributes(:piece_type => promote_piece_type, :image_name => promote_piece_image)
    
    flash[:alert] = "#{old_piece_type} is promoted to #{promote_piece_type}"
    render_notifications
  end


  def destroy
    piece.destroy
    render :nothing => true
  end

  private
  def piece
    @piece ||= Piece.find(params[:id]) 
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord, :game_id, :piece_type)
  end

  def not_moved?(x, y)
    @piece.x_coord == x && @piece.y_coord == y
  end

  def new_x 
    piece_params[:x_coord].to_i

  end

  def new_y
    piece_params[:y_coord].to_i
  end

  def picked_wrong_piece_color?
    piece.game.playerturn != piece.color
  end

  def not_player_turn?
    piece.game.playerturn != player_color
  end

  def player_color
    if current_user == piece.game.white_player
      "white"
    else
      "black"
    end
  end

  def get_image_name(piece_color, piece_type)
    case piece_color
    when "black"
      piece_color = 'b'
    when "white"
      piece_color = 'w'
    end

    case piece_type
    when "Rook"
      piece_type = 'r'
    when "Queen"
      piece_type = 'q'
    when "Bishop"
      piece_type = 'b'
    when "Knight"
      piece_type = 'n'
    end

    image_name = 'pieces/'+ piece_color + piece_type + '.png'
  end

  def render_notifications
    render  :partial => "layouts/notice_alert"
  end
     
end
