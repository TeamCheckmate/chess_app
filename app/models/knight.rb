class Knight < Piece
  def move_valid?(new_x, new_y) 
    # knight moves either two sqaures up and one over or
    # two squares over and one up in any direction
    valid_vertical_move?(new_x, new_y)   || 
    valid_horizontal_move?(new_x, new_y)
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
