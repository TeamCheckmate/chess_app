class Queen < Piece

  def move_valid?(new_x, new_y)
    return false if self.game.is_obstructed?([x_coord, y_coord], [new_x,new_y])
    valid_vertical_move?(new_x, new_y)   || 
    valid_horizontal_move?(new_x, new_y) ||
    valid_diagonal_move?(new_x, new_y)  
  end

  private
  def valid_vertical_move?(new_x, new_y)
    new_x == x_coord && new_y != y_coord
  end
 
  def valid_horizontal_move?(new_x, new_y)
    new_y == y_coord && new_x != x_coord
  end

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
