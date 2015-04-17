module GamesHelper
  def chess_piece (x,y)
    piece = @pieces.where(x_coord: x, y_coord: y).first
    return if piece.nil?
    # image_tag piece.image_name
    return piece
  end
end
