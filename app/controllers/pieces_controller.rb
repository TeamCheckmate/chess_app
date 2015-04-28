class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :piece, :only => [:show, :update, :destroy]
  protect_from_forgery
  skip_before_filter  :verify_authenticity_token
  
  def show
    @game = @piece.game_id
  end

  def update
    @game_id = @piece.game_id
    @game = Game.where(id: @game_id).first

    if @piece.move_valid?(new_x, new_y)
      status_code = @piece.move_to!(new_x, new_y)
       if status_code == :valid_move
        render :nothing => true
      elsif status_code == :reload
        render :json => {:message => "piece taken"}, :status => :reset_content
      else
        render :json => {:message => "Invalid move"}, :status => :unprocessable_entity        
      end
    else
      render :json => {:message => "Invalid move"}, :status => :unprocessable_entity
    end
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
    params.require(:piece).permit(:x_coord, :y_coord, :game_id)
  end

  def new_x 
    piece_params[:x_coord].to_i

  end

  def new_y
    piece_params[:y_coord].to_i
  end
end
