class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: "User"
  belongs_to :black_player, class_name: "User"
  has_many   :pieces
  after_create :populate_the_pieces!

  INITIAL_PIECE_LOCATIONS = [
    {:piece_type => "Rook", :x_coord => 0, :y_coord => 7, :color => 'black'},
    {:piece_type => "Rook", :x_coord => 7, :y_coord => 7, :color => 'black'},
    {:piece_type => "Rook", :x_coord => 0, :y_coord => 0, :color => 'white'},
    {:piece_type => "Rook", :x_coord => 7, :y_coord => 0, :color => 'white'},
    {:piece_type => "Knight", :x_coord => 1, :y_coord => 7, :color => 'black'},
    {:piece_type => "Knight", :x_coord => 6, :y_coord => 7, :color => 'black'},
    {:piece_type => "Knight", :x_coord => 1, :y_coord => 0, :color => 'white'},
    {:piece_type => "Knight", :x_coord => 6, :y_coord => 0, :color => 'white'},
    {:piece_type => "Bishop", :x_coord => 2, :y_coord => 7, :color => 'black'},
    {:piece_type => "Bishop", :x_coord => 5, :y_coord => 7, :color => 'black'},
    {:piece_type => "Bishop", :x_coord => 2, :y_coord => 0, :color => 'white'},
    {:piece_type => "Bishop", :x_coord => 5, :y_coord => 0, :color => 'white'},
    {:piece_type => "Queen", :x_coord => 3, :y_coord => 7, :color => 'black'},
    {:piece_type => "Queen", :x_coord => 3, :y_coord => 0, :color => 'white'},
    {:piece_type => "King", :x_coord => 4, :y_coord => 7, :color => 'black'},
    {:piece_type => "King", :x_coord => 4, :y_coord => 0, :color => 'white'},
    {:piece_type => "Pawn", :x_coord => 0, :y_coord => 6, :color => 'black'},
    {:piece_type => "Pawn", :x_coord => 1, :y_coord => 6, :color => 'black'},
    {:piece_type => "Pawn", :x_coord => 2, :y_coord => 6, :color => 'black'},
    {:piece_type => "Pawn", :x_coord => 3, :y_coord => 6, :color => 'black'},
    {:piece_type => "Pawn", :x_coord => 4, :y_coord => 6, :color => 'black'},
    {:piece_type => "Pawn", :x_coord => 5, :y_coord => 6, :color => 'black'},
    {:piece_type => "Pawn", :x_coord => 6, :y_coord => 6, :color => 'black'},
    {:piece_type => "Pawn", :x_coord => 7, :y_coord => 6, :color => 'black'},
    {:piece_type => "Pawn", :x_coord => 0, :y_coord => 1, :color => 'white'},
    {:piece_type => "Pawn", :x_coord => 1, :y_coord => 1, :color => 'white'},
    {:piece_type => "Pawn", :x_coord => 2, :y_coord => 1, :color => 'white'},
    {:piece_type => "Pawn", :x_coord => 3, :y_coord => 1, :color => 'white'},
    {:piece_type => "Pawn", :x_coord => 4, :y_coord => 1, :color => 'white'},
    {:piece_type => "Pawn", :x_coord => 5, :y_coord => 1, :color => 'white'},
    {:piece_type => "Pawn", :x_coord => 6, :y_coord => 1, :color => 'white'},
    {:piece_type => "Pawn", :x_coord => 7, :y_coord => 1, :color => 'white'}

  ]
  def populate_the_pieces!
      INITIAL_PIECE_LOCATIONS.each do |piece|
        self.pieces.create(piece)
      end
  end

  # def initialize
  #   @board=Array.new(7){Array.new(7)}
  # end

  # def populate_new_board
  #   (0..7).each do |row|
  #     (0..7).each do |cell|
  #       @board[row][cell]='pawn'
  #     end
  #   end
  #   @board
  # end

  def is_obstructed(initial_x: 0, initial_y: 0, final_x: 0, final_y: 0)

    if initial_x == final_x
      is_obstructed_vertical(x: initial_x, initial_y: initial_y, final_y: final_y)
    elsif initial_y == final_y
      is_obstructed_horizontal(y: initial_y, initial_x: initial_x, final_x: final_y)
    end
  end

  def is_obstructed_vertical(x: 0, initial_y: 0, final_y: 0)
    
    if initial_y == final_y 
      return raise "Not Allowed"
    end

    #get all pieces on column, x
    pieces_vertical = self.pieces.where(x_coord: x)

    if final_y > initial_y 
      upper_y = final_y 
      lower_y = initial_y
    else 
      upper_y = initial_y
      lower_y = final_y
    end

    pieces_vertical.each do |piece|
      if piece.y_coord.between?(lower_y, upper_y)
        return true
      end
    end

    false
  end

  def is_obstructed_horizontal(y: 0, initial_x: 0, final_x: 0)

    if initial_x == final_x
      return raise "Not Allowed"
    end

    #get all pieces on row, y
    pieces_horizontal = self.pieces.where(y_coord: y)

    true
  end

end
