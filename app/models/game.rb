class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: "User"
  belongs_to :black_player, class_name: "User"
  has_many   :pieces
  after_create :populate_the_pieces!

  
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
    else
      is_obstructed_diagonal(initial_x: initial_x, initial_y: initial_y, final_x: final_x, final_y: final_y)
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

    if final_x > initial_x 
      upper_x = final_x 
      lower_x = initial_x
    else 
      upper_x = initial_x
      lower_x = final_x
    end

    pieces_horizontal.each do |piece|
      if piece.x_coord.between?(lower_x, upper_x)
        return true
      end
    end

    false
  end

  def is_obstructed_diagonal(initial_x: 0, initial_y: 0, final_x: 0, final_y: 0)
    x = (initial_x - final_x).abs
    y = (initial_y - final_y).abs

    if x == y
      if final_x > initial_x
        if final_y > initial_y 
          (initial_x+1..final_x).each do |x|
            initial_y += 1
            if !self.pieces.where(x_coord: x, y_coord: initial_y).empty?
              return true
            end
          end

          false
        else
          (initial_x+1..final_x).each do |x|
            initial_y -= 1
            if !self.pieces.where(x_coord: x, y_coord: initial_y).empty?
              return true
            end
          end

          false
        end
      else  
        if final_y > initial_y
          (initial_y+1..final_y).each do |y|
            initial_x -= 1
            if !self.pieces.where(x_coord: initial_x, y_coord: y).empty?
              return true
            end
          end

          false
        else
          (final_x..initial_x-1).reverse_each do |x|
            initial_y -= 1
            if !self.pieces.where(x_coord: x, y_coord: initial_y).empty?
              return true
            end
          end
          
          false
        end
      end
    else 
      raise "Not Allowed"
    end     
  end
end

