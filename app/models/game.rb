class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: "User"
  belongs_to :black_player, class_name: "User"
  has_many   :pieces
  has_many :moves, through: :pieces
  after_create :populate_the_pieces!
  require 'pry'

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
    start_x = start_coord[0]      # start x coordinate
    start_y = start_coord[1]      # start y coordinate
    destn_x = destn_coord[0]      # x coordinate that the piece will be dropped
    destn_y = destn_coord[1]      # y coordinate that the piece will be dropped

    start_piece= self.pieces.where(x_coord: start_x, y_coord: start_y).first
    destn_piece = self.pieces.where(x_coord: destn_x, y_coord: destn_y).first

    return true if destn_x < 0 || destn_x > 7
    return true if destn_y < 0 || destn_y > 7

    if start_x == destn_x    
      if start_piece.piece_type == "Pawn" && start_piece.color == "white" 
        return true if !piece_in_front?(start_x, start_y, 1) 
      elsif  start_piece.piece_type == "Pawn" && start_piece.color == "black" 
        return true if !piece_in_front?(start_x, start_y, -1) 
      end
    end

    # if start_piece.piece_type == "Rook" && self.castle?(destn_x, start_piece.color)
    #   return false
    # end

    if !destn_piece.nil? && destn_piece.color == start_piece.color 
      return true
    end

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

  def square_occupied(x_coord, y_coord)
    self.pieces.where(x_coord: x_coord, y_coord: y_coord)
  end

  def in_check?(color)
    #look for king of a color, find the coordinates, query opposing teams' pieces and see if a valid move
    #allows the king to be captured
    check_king = self.pieces.where(piece_type: "King", color: color).first
    king_x = check_king.x_coord
    king_y = check_king.y_coord
    if color == "white"
      opp_color = "black"
    else
      opp_color = "white"
    end
    opp_pieces = self.pieces.where(color: opp_color)
    opp_pieces.each do |p|
      if p.x_coord != nil && p.move_valid?(king_x, king_y)
        return true
      end
    end
    return false
  end

  def not_stalemate?(color)
    pieces = self.pieces.where(:color => color)
    pieces.each do |piece|
      valid = piece.valid_moves
      old_x = piece.x_coord
      old_y = piece.y_coord
      valid.each do |v|
        # return true 
        if piece.move_valid?(v[0], v[1])
          piece.update_attributes(:x_coord => v[0], :y_coord => v[1])
          if !in_check?(color)
            piece.update_attributes(:x_coord => old_x, :y_coord => old_y)
            return true
          else
            piece.update_attributes(:x_coord => old_x, :y_coord => old_y)
          end
        end
      end
    end
    return false
  end

   def castle?(new_x, color)
    #no pieces between rook and king
    #rook and king must be in original positions
    castle_king = self.pieces.where(:piece_type => "King", :color => color).first
    return false if (castle_king.x_coord - new_x).abs != 2
    if new_x > 4 
      castle_rook = self.pieces.where(:piece_type => "Rook", :color => color, :x_coord => 7).first
      operation = :+
    else
      castle_rook = self.pieces.where(:piece_type => "Rook", :color => color, :x_coord => 0).first
      operation = :-
    end
      if !castle_rook.present?
        return false
      elsif castle_king.moves.empty? && castle_rook.moves.empty?
        return false if self.in_check?(castle_king.color)
        old_x = castle_king.x_coord
        new_x = old_x
          2.times do |x|
            new_x = new_x.send(operation, 1)
            if self.pieces.where(:x_coord => new_x, :y_coord => castle_king.y_coord).first.nil?
              move_square = true
            else
              move_square = false
            end
            castle_king.update_attributes(x_coord: new_x)
            if self.in_check?(castle_king.color) || !move_square
              castle_king.update_attributes(x_coord: old_x)
              return false
            end
          end
          castle_king.update_attributes(x_coord: old_x)
        return true
      else
        return false
      end
  end


  def check_mate?
    # check for check
    check_color = nil
    if in_check?("white")
      check_king = self.pieces.where(piece_type: "King", color: "white").first
      check_color = "black"
    elsif in_check?("black")
      check_king = self.pieces.where(piece_type: "King", color: "black").first
      check_color = "white"
    end
    
    if check_color.nil?
      return false
    else
      # check if king can move out of check    

      old_x = check_king.x_coord
      old_y = check_king.y_coord
      [:+,:-].each do |operation|
          new_x = check_king.x_coord.send(operation,1)
          new_y = check_king.y_coord.send(operation,1)
          if check_king.move_valid?(new_x, check_king.y_coord)
            check_king.update_attributes(:x_coord => new_x)
            if !in_check?(check_king.color)
              check_king.update_attributes(:x_coord => old_x)
              return false
            end
            check_king.update_attributes(:x_coord => old_x)
          end
          if check_king.move_valid?(check_king.x_coord, new_y)
            check_king.update_attributes(:y_coord => new_y)
            if !in_check?(check_king.color)
              check_king.update_attributes(:y_coord => old_y)
              return false
            end
            check_king.update_attributes(:y_coord => old_y)
          end
          [:+,:-].each do |operation_2|
             new_y = check_king.y_coord.send(operation_2, 1)
             if check_king.move_valid?(new_x, new_y)
               check_king.update_attributes(:x_coord => new_x, :y_coord => new_y)
               if !in_check?(check_king.color)
                check_king.update_attributes(:x_coord => old_x, :y_coord => old_y)
               
                return false
               end
               check_king.update_attributes(:x_coord => old_x, :y_coord => old_y)
             end
          end
      end

      check_piece = find_check_piece(check_color, check_king)

      defend_pieces = self.pieces.where(color: check_king.color)

      if check_piece.piece_type != "Knight"
        upper_x = [check_piece.x_coord, check_king.x_coord].max
        lower_x = [check_piece.x_coord, check_king.x_coord].min
        upper_y = [check_piece.y_coord, check_king.y_coord].max
        lower_y = [check_piece.y_coord, check_king.y_coord].min
  
        check_line = []
        if upper_x == lower_x
          (lower_y+1...upper_y).each do |y|
            check_line << [upper_x, y]
          end
        elsif upper_y == lower_y
          (lower_x+1...upper_x).each do |x|
            check_line << [x, upper_y] 
          end
        else
          y = lower_y+1
          (lower_x+1...upper_x).each do |x|
            check_line << [x, y]
            y += 1
          end
        end
  
        check_line.each do |square|
          defend_pieces.each do |piece|
            if piece.x_coord != nil && piece.piece_type != 'King' && piece.move_valid?(square[0], square[1])
              old_x = piece.x_coord
              old_y = piece.y_coord
              piece.update_attributes(:x_coord => square[0], :y_coord => square[1])
              if !in_check?(piece.color)
                piece.update_attributes(:x_coord => old_x, :y_coord => old_y)
                return false
              end
              piece.update_attributes(:x_coord => old_x, :y_coord => old_y)
            end
          end
        end
      end

      # try and take the piece
      attack_x = check_piece.x_coord
      attack_y = check_piece.y_coord
      defend_pieces.each do |piece|
        if !piece.x_coord.nil? && piece.move_valid?(attack_x, attack_y)
          old_x = piece.x_coord
          old_y = piece.y_coord
          check_piece.update_attributes(:x_coord => nil, :y_coord => nil)
          piece.update_attributes(:x_coord => attack_x, :y_coord => attack_y)
          if !in_check?(piece.color)
            piece.update_attributes(:x_coord => old_x, :y_coord => old_y)
            check_piece.update_attributes(:x_coord => attack_x, :y_coord => attack_y)
            return false
          end
          piece.update_attributes(:x_coord => old_x, :y_coord => old_y)
          check_piece.update_attributes(:x_coord => attack_x, :y_coord => attack_y)
        end
   
      end
    end

    true
  end

  private

  def find_check_piece(check_color, check_king)
    check_pieces = self.pieces.where(color: check_color)
    check_pieces.each do |piece|
      if piece.move_valid?(check_king.x_coord, check_king.y_coord)
        return piece
      end
    end
  end

  def piece_in_front?(x_coord, y_coord, operater)
    self.pieces.where(x_coord: x_coord, y_coord: y_coord+operater).empty?
  end
  
  # This method checks both conditions, vertical and horizontal depending on the argument, direction.
  # dir takes either :vertical or :horizontal, which indicates whether the direction is vertical or horizontal.
  # dir_coord is either the coordinate of the column or row that is fixed. 
  def vertical_horizontal(dir, dir_coord, start, destn)
    # check if input is valid
    # raise "Not Allowed" if start == destn

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

    # raise "Not Allowed" if x != y       #raise an exception if it's not diagonal 

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

   # There are four possible cases we need to consider: 
    # 1. x coordinate increases, y coordinate increases(x_dir: :+, y_dir: :+)
    # 2. x coordinate increases, y coordinate decreases(x_dir: :+, y_dir: :-)
    # 3. x coordinate decreases, y coordinate increases(x_dir: :-, y_dir: :+)
    # 4. x coordinate decreases, y coordinate decreases(x_dir: :-, y_dir: :-)

    # determine whether the start x coordinate or destn x coordinate is bigger
    # the bigger one should be the upper bound
    # the smaller one should be the lower bound
  def iterate_diagonal(x_dir, y_dir, start_x, start_y, destn_x, destn_y) 
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

 

end

