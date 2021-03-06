class Queen < Piece

  def move_valid?(new_x, new_y)
    return false if self.game.is_obstructed?([x_coord, y_coord], [new_x,new_y])
    valid_vertical_move?(new_x, new_y)   || 
    valid_horizontal_move?(new_x, new_y) ||
    valid_diagonal_move?(new_x, new_y)  
  end

  def valid_moves
    valid_move =[]
    return valid_move if x_coord == nil
    
    (-7..7).each do |x|
        coords = [x_coord + x, y_coord + x]
        valid_move << coords
        coords = [x_coord + x, y_coord]
        valid_move << coords
        coords = [x_coord, y_coord + x]
        valid_move << coords
    end
    valid_move
  end

  def original_x_coord
    [4]
  end

  def type
    "Queen"
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
