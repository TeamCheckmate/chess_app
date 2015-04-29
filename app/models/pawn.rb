class Pawn < Piece 
  def move_valid?(new_x, new_y)
    return false if self.game.is_obstructed?([x_coord, y_coord], [new_x,new_y])

    valid_vertical_move?(new_y, new_x)   || 
    valid_start_move?(new_y, new_x) ||
    valid_diagonal_move?(new_x, new_y)  
  end

  private 
  def valid_vertical_move?(new_y, new_x)
    y_within_one?(new_y) && same_x?(new_x)
  end

  def valid_start_move?(new_y, new_x)
    if y_coord == 1 && color == "white" ||
      y_coord == 6 && color == "black"
      y_within_two?(new_y) && same_x?(new_x)
    end
  end

  def valid_diagonal_move?(new_x, new_y)
    if x_within_one?(new_x) && y_within_one?(new_y)
      destn_piece = self.game.square_occupied(new_x, new_y).first
      if !destn_piece.nil? && destn_piece.color != self.color 
        return true
      end
    end
    return false
  end 

  def same_x?(new_x)
    new_x == x_coord
  end

  def y_within_one?(new_y)
    if color == "white"
    (new_y - y_coord) == 1
    else
     (new_y - y_coord) == -1
   end
  end

  def y_within_two?(new_y)
     if color == "white"
    (new_y - y_coord) == 2
    else
     (new_y - y_coord) == -2
   end
  end

  def x_within_one?(new_x)
    (new_x - x_coord).abs == 1 
  end     
end
