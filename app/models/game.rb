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
# is_obstructed? returns true if there are pieces between two coordinates
# raise exception if the input coordinates are not in vertical, horizontal or diagonal direciton.
# intial_coord and destn_coord accept an array with a length of 2, [x_coordinate, y_coordinate]
  def is_obstructed?(start_coord, destn_coord)
    start_x = start_coord[0]  # start x coordinate
    start_y = start_coord[1]  # start y coordinate
    destn_x = destn_coord[0]      # x coordinate that the piece will be dropped
    destn_y = destn_coord[1]      # y coordinate that the piece will be dropped

    # only 3 directions are valid
    # vertical, horizontal and diagonal
    if start_x == destn_x             
      vertical_horizontal(:vertical, start_x, start_y, destn_y)
    elsif start_y == destn_y 
      vertical_horizontal(:horizontal, start_y, start_x, destn_x)
    else                          
      diagonal(start_x, start_y, destn_x, destn_y)
    end
  end
   
### helper methods
  # This method checks both conditions, vertical and horizontal depending on the argument, direction.
  # dir takes either :vertical or :horizontal, which indicates whether the direction is vertical or horizontal.
  # dir_coord is either the coordinate of the column or row that is fixed. 
  def vertical_horizontal(dir, dir_coord, start, destn)
    # check if input is valid
    raise "Not Allowed" if start == destn

    # Determine whether start or destn is bigger and smaller
    upper = [start, destn].max
    lower = [start, destn].min

    if dir == :vertical               # direction is vertical
      self.pieces.where(x_coord: dir_coord).where("y_coord > ? AND y_coord < ?", lower, upper).present?
    else                              # direction is horizontal
      self.pieces.where(y_coord: dir_coord).where("x_coord > ? AND x_coord < ?", lower, upper).present?
    end

  end

  # This method checks the diagonal direction.
  # Exception will be raised if the input coordinates do not form a right triangle.
  # Once we determine whether x and y coordinates increase or decrease, we can iterate through
  # each coordinate on the diagonal accordingly. 
  def diagonal(start_x, start_y, destn_x, destn_y)
    x = (start_x - destn_x).abs
    y = (start_y - destn_y).abs

    raise "Not Allowed" if x != y       #raise an exception if it's not diagonal 

    # determine x and y coordinates are increasing or decreasing
    x_dir = x_y_dir(start_x, destn_x)
    y_dir = x_y_dir(start_y, destn_y)
    
    # iterate through the diagonal 
    iterate_diagonal(x_dir, y_dir, start_x, start_y, destn_x, destn_y)
  end

### helper methods for diagonal metho
  # return :+ (increasing) if the destn coordinate is bigger than start coordinate
  # else return :- (decreasing)
  def x_y_dir(start, destn)
    destn > start ? :+ : :-
  end



  def iterate_diagonal(x_dir, y_dir, start_x, start_y, destn_x, destn_y)
    # There are four possible cases we need to consider: 
    # 1. x coordinate increases, y coordinate increases(x_dir: :+, y_dir: :+)
    # 2. x coordinate increases, y coordinate decreases(x_dir: :+, y_dir: :-)
    # 3. x coordinate decreases, y coordinate increases(x_dir: :-, y_dir: :+)
    # 4. x coordinate decreases, y coordinate decreases(x_dir: :-, y_dir: :-)

    # determine whether the start x coordinate or destn x coordinate is bigger
    # the bigger one should be the upper bound
    # the smaller one should be the lower bound
    upper_x = [start_x, destn_x].max
    lower_x = [start_x, destn_x].min

    # determine the direction of iterating through x coordinates
    # each if x coordinate increases (iterating through from lower bound to upper bound)
    # reverse_each if x coordinate decreases (iterating through from upper bound to lower bound)
    x_iterate = x_dir == :+ ? :each : :reverse_each

    (lower_x+1...upper_x).send(x_iterate) do |x|
      start_y = start_y.send(y_dir, 1)
      
      return true if !self.pieces.where(x_coord: x, y_coord: start_y).empty?
    end

    false
  end
#######################

end

