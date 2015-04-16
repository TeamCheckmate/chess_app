class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: "User"
  belongs_to :black_player, class_name: "User"
  has_many   :pieces
  after_create :populate_the_pieces!

  delegate :pawns, :rooks, :knights, :bishops, :kings, :queens, to: :pieces
  
  INITIAL_PIECE_LOCATIONS = [

    {:y_coord => 7, :x_coord => 0, :piece_type => "Rook", :color => 'black', :image_name => 'pieces/br.png'},
    {:y_coord => 7, :x_coord => 1, :piece_type => "Knight", :color => 'black', :image_name => 'pieces/bn.png'},
    {:y_coord => 7, :x_coord => 2, :piece_type => "Bishop", :color => 'black', :image_name => 'pieces/bb.png'},
    {:y_coord => 7, :x_coord => 3, :piece_type => "King", :color => 'black', :image_name => 'pieces/bk.png'},
    {:y_coord => 7, :x_coord => 4, :piece_type => "Queen", :color => 'black', :image_name => 'pieces/bq.png'},
    {:y_coord => 7, :x_coord => 5, :piece_type => "Bishop", :color => 'black', :image_name => 'pieces/bb.png'},
    {:y_coord => 7, :x_coord => 6, :piece_type => "Knight", :color => 'black', :image_name => 'pieces/bn.png'},
    {:y_coord => 7, :x_coord => 7, :piece_type => "Rook", :color => 'black', :image_name => 'pieces/br.png'},

    {:y_coord => 6, :x_coord => 0, :piece_type => "Pawn", :color => 'black', :image_name => 'pieces/bp.png'},
    {:y_coord => 6, :x_coord => 1, :piece_type => "Pawn", :color => 'black', :image_name => 'pieces/bp.png'},
    {:y_coord => 6, :x_coord => 2, :piece_type => "Pawn", :color => 'black', :image_name => 'pieces/bp.png'},
    {:y_coord => 6, :x_coord => 3, :piece_type => "Pawn", :color => 'black', :image_name => 'pieces/bp.png'},
    {:y_coord => 6, :x_coord => 4, :piece_type => "Pawn", :color => 'black', :image_name => 'pieces/bp.png'},
    {:y_coord => 6, :x_coord => 5, :piece_type => "Pawn", :color => 'black', :image_name => 'pieces/bp.png'},
    {:y_coord => 6, :x_coord => 6, :piece_type => "Pawn", :color => 'black', :image_name => 'pieces/bp.png'},
    {:y_coord => 6, :x_coord => 7, :piece_type => "Pawn", :color => 'black', :image_name => 'pieces/bp.png'},


    {:y_coord => 1, :x_coord => 0, :piece_type => "Pawn", :color => 'white', :image_name => 'pieces/wp.png'},
    {:y_coord => 1, :x_coord => 1, :piece_type => "Pawn", :color => 'white', :image_name => 'pieces/wp.png'},
    {:y_coord => 1, :x_coord => 2, :piece_type => "Pawn", :color => 'white', :image_name => 'pieces/wp.png'},
    {:y_coord => 1, :x_coord => 3, :piece_type => "Pawn", :color => 'white', :image_name => 'pieces/wp.png'},
    {:y_coord => 1, :x_coord => 4, :piece_type => "Pawn", :color => 'white', :image_name => 'pieces/wp.png'},
    {:y_coord => 1, :x_coord => 5, :piece_type => "Pawn", :color => 'white', :image_name => 'pieces/wp.png'},
    {:y_coord => 1, :x_coord => 6, :piece_type => "Pawn", :color => 'white', :image_name => 'pieces/wp.png'},
    {:y_coord => 1, :x_coord => 7, :piece_type => "Pawn", :color => 'white', :image_name => 'pieces/wp.png'},

    {:y_coord => 0, :x_coord => 0, :piece_type => "Rook", :color => 'white', :image_name => 'pieces/wr.png'},
    {:y_coord => 0, :x_coord => 1, :piece_type => "Knight", :color => 'white', :image_name => 'pieces/wn.png'},
    {:y_coord => 0, :x_coord => 2, :piece_type => "Bishop", :color => 'white', :image_name => 'pieces/wb.png'},
    {:y_coord => 0, :x_coord => 3, :piece_type => "King", :color => 'white', :image_name => 'pieces/wk.png'},
    {:y_coord => 0, :x_coord => 4, :piece_type => "Queen", :color => 'white', :image_name => 'pieces/wq.png'},
    {:y_coord => 0, :x_coord => 5, :piece_type => "Bishop", :color => 'white', :image_name => 'pieces/wb.png'},
    {:y_coord => 0, :x_coord => 6, :piece_type => "Knight", :color => 'white', :image_name => 'pieces/wn.png'},
    {:y_coord => 0, :x_coord => 7, :piece_type => "Rook", :color => 'white', :image_name => 'pieces/wr.png'},
  ]
  def populate_the_pieces!
      INITIAL_PIECE_LOCATIONS.each do |piece|
        self.pieces.create(piece)
      end
  end

########################
# is_obstructed returns true if there are pieces between two coordinates
# raise exception if the input coordinates are not in vertical, horizontal or diagonal direciton.
# intial_coord and final_coord accept an array with a length of 2, [x_coordinate, y_coordinate]
  def is_obstructed(initial_coord, final_coord)
    initial_x = initial_coord[0]
    initial_y = initial_coord[1]
    final_x = final_coord[0]
    final_y = final_coord[1]

    if initial_x == final_x    
      vertical_horizontal(:vertical, initial_x, initial_y, final_y)
    elsif initial_y == final_y 
      vertical_horizontal(:horizontal, initial_y, initial_x, final_y)
    else    
      diagonal(initial_x, initial_y, final_x, final_y)
    end
  end
   
### helper methods
  # This method checks both conditions, vertical and horizontal. 
  # dir takes either :vertical or :horizontal, which indicates whether the direction is vertical or horizontal.
  # dir_coord is either coordinate of the column or row that is the same for initial and final.
  def vertical_horizontal(dir, dir_coord, initial, final)
    # check if input is valid
    raise "Not Allowed" if initial == final

    upper = [initial, final].max
    lower = [initial, final].min

    if dir == :vertical               # direction is vertical
      self.pieces.where(x_coord: dir_coord).where("y_coord >= ? AND y_coord <= ?", lower, upper).present?
    else                              # direction is horizontal
      self.pieces.where(y_coord: dir_coord).where("x_coord >= ? AND x_coord <= ?", lower, upper).present?
    end

  end

  # This method checks the diagonal direction.
  # Exception will be raised if the input coordinates do not form a right triangle.
  # Once we determine whether x and y coordinates increase or decrease, we can iterate through
  # each coordinate on the diagonal accordingly. 
  def diagonal(initial_x, initial_y, final_x, final_y)
    x = (initial_x - final_x).abs
    y = (initial_y - final_y).abs

    raise "Not Allowed" if x != y       #raise an exception if it's not diagonal 

    # determine x and y coordinate directions
    x_dir = x_y_dir(initial_x, final_x)
    y_dir = x_y_dir(initial_y, final_y)
    
    # iterate through the diagonal based on x and y direction
    iterate_diagonal(x_dir, y_dir, initial_x, initial_y, final_x, final_y)
  end

### helper methods for diagonal method
  def x_y_dir(initial, final)
    final > initial ? :+ : :-
  end

  def iterate_diagonal(x_dir, y_dir, initial_x, initial_y, final_x, final_y)
    # determine the upper and lower bound for x coordinates
    upper_x = [initial_x, final_x].max
    lower_x = [initial_x, final_x].min

    # determine the direction of iterating through x coordinates
    # each if x coordinate increases 
    # reverse_each if x coordinate decreases
    x_iterate = x_dir == :+ ? :each : :reverse_each

    (lower_x+1...upper_x).send(x_iterate) do |x|
      initial_y = initial_y.send(y_dir, 1)
      
      return true if !self.pieces.where(x_coord: x, y_coord: initial_y).empty?
    end

    false
  end
#######################

end

