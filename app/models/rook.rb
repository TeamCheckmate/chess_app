class Rook < Piece
  def move_valid?(new_x, new_y)

    return false if self.game.is_obstructed?([x_coord, y_coord], [new_x,new_y])
    # rook moves any number of squares in any direction
    valid_vertical_move?(new_x, new_y) || valid_horizontal_move?(new_x, new_y)
  end
 
  def valid_moves
    valid_move =[]
    (-7..7).each do |x|
          coords = [x_coord, y_coord + x]
          valid_move << coords
          coords = [x_coord + x, y_coord]
          valid_move << coords
      end
    valid_move
  end

  private
  def valid_vertical_move?(new_x, new_y)
    new_x == x_coord && new_y != y_coord
  end
 
  def valid_horizontal_move?(new_x, new_y)
    new_y == y_coord && new_x != x_coord
  end

end
