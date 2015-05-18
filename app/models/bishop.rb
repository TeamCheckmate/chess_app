class Bishop < Piece 
  def move_valid?(new_x, new_y)
    return false if self.game.is_obstructed?([x_coord, y_coord], [new_x,new_y])
    valid_diagonal_move?(new_x, new_y) 
  end

  def valid_moves
      valid_move =[]
      (-7..7).each do |x|
          coords = [x_coord + x, y_coord + x]
          valid_move << coords
      end
    valid_move
  end

  private
  def valid_diagonal_move?(new_x, new_y)
    x_distance(new_x) == y_distance(new_y) && x_distance(new_x) != 0
  end
 
  def x_distance(new_x)
    (new_x - x_coord).abs
  end
 
  def y_distance(new_y)
    (new_y - y_coord).abs
  end
end
