class PiecesController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery
  skip_before_filter  :verify_authenticity_token
  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game_id
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game_id
    @piece.update_attributes(piece_params)
    render :nothing => true
  end

  private

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord, :game_id)
  end
end
