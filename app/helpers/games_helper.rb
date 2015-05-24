module GamesHelper
  def chess_piece (x,y, current_game)
    piece = current_game.pieces.where(x_coord: x, y_coord: y).first
    return if piece.nil?

    piece
  end

  def find_piece(piece_id)
  	piece = @pieces.where(id: piece_id).first
  end
end
