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
    @game_id = piece.game_id
    game = Game.where(id: @game_id).first

    if piece.move_valid?(new_x, new_y)
      status_code = piece.move_to!(new_x, new_y)

      if game.check_mate?
       render :json => {:message => "check mate"}, :status => :no_content
      elsif status_code == :valid_move
        render :nothing => true
      elsif status_code == :reload
        render :json => {:message => "piece taken"}, :status => :reset_content
      elsif status_code == :pawn_promote
        render :json => {:pawn_id => piece.id, :message => "pawn promoted"}, :status => :partial_content
      elsif status_code == :castle
        render :json => {:message => "castled"}, :status => :reset_content
      else
        render :json => {:message => "Invalid move"}, :status => :unprocessable_entity        
      end
    else
      render :json => {:message => "Invalid move"}, :status => :unprocessable_entity
    end
  end

  def pawn_promote 
    @piece = Piece.find(params[:piece_id])
    promote_piece_type = params[:piece_type]
    piece_color = @piece.color

    
    case piece_color
    when "black"
      image_color = 'b'
    when "white"
      image_color = 'w'
    end

    case promote_piece_type
    when "Rook"
      image_type = 'r'
    when "Queen"
      image_type = 'q'
    when "Bishop"
      image_type = 'b'
    end

    promote_piece_image = 'pieces/'+ image_color + image_type + '.png'
    
    @piece.update_attributes(:piece_type => promote_piece_type, :image_name => promote_piece_image)
    render :json => {:message => 'updated piece type'}
  end

  def destroy
    @game = @piece.game_id
    @piece.destroy
    render :nothing => true
  end

  private
  def piece
    @piece = Piece.find(params[:id]) 
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord, :game_id, :piece_type)
  end

  def new_x 
    piece_params[:x_coord].to_i

  end

  def new_y
    piece_params[:y_coord].to_i
  end
end
