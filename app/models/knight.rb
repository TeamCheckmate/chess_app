class Knight < Piece
  def move_valid?(new_x, new_y) 
    # knight moves either two sqaures up and one over or
    # two squares over and one up in any direction
    valid_vertical_move?(new_x, new_y)   || 
    valid_horizontal_move?(new_x, new_y)
  end

  def valid_moves
    valid_move =[]
    return valid_move if x_coord == nil

    move_two = [-2, 2]
    move_one = [-1, 1]

    move_two.each do |two|
      move_one.each do |one|  
        coords = [x_coord + two, y_coord + one]
        valid_move << coords
        coords = [x_coord + one, y_coord + two]
        valid_move << coords
      end 
    end   
     
    valid_move
  end

  def original_x_coord
    [1, 6]
  end
  
  private

  def valid_vertical_move?(new_x, new_y)
    y_within_two?(new_y) && x_within_one?(new_x)
  end

  def valid_horizontal_move?(new_x, new_y)
    x_within_two?(new_x) && y_within_one?(new_y)
  end

  def y_within_one?(new_y)
    (new_y - y_coord).abs ==1
  end

  def y_within_two?(new_y)
    (new_y - y_coord).abs == 2 
  end

  def x_within_one?(new_x)
    (new_x - x_coord).abs ==1
  end

  def x_within_two?(new_x)
    (new_x - x_coord).abs == 2 
  end 
end
