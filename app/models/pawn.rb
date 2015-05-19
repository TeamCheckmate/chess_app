class Pawn < Piece 
  def move_valid?(new_x, new_y)
    return false if self.game.is_obstructed?([x_coord, y_coord], [new_x,new_y])

    valid_vertical_move?(new_y, new_x)   || 
    valid_start_move?(new_y, new_x) ||
    valid_diagonal_move?(new_x, new_y) ||
    en_passant?(new_x, new_y)
  end

  def en_passant?(new_x, new_y)
    if self.color == "white"
      operation = -1
    else
      operation = 1
    end
    check_y = new_y + operation
    behind_piece = self.game.square_occupied(new_x, check_y).first
    if x_within_one?(new_x) && y_within_one?(new_y)
      if !behind_piece.nil? && behind_piece.piece_type == "Pawn" && behind_piece.color != self.color
        if behind_piece.id == self.game.moves.last.piece_id && behind_piece.moves.count == 1
          return true
        end
      end
    end
    false
  end

  def valid_moves
      valid_move =[]
      (-1..1).each do |x|
        (-1..1).each do |y|
          coords = [x_coord + x, y_coord + y]
          valid_move << coords
        end
      end
      coords = [x_coord, y_coord + 2]
      valid_move << coords
      coords = [x_coord, y_coord - 2]
      valid_move << coords
    valid_move
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

  def threefold_repetiton?(new_x, new_y)
    false
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
