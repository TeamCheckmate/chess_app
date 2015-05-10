class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :moves
  self.inheritance_column = :piece_type
  require 'pry'

  validate :x_coord, :y_coord, presence: true

  def create_move!
  #need to find game associated with piece  
    moved_piece = self.game.pieces.order("updated_at").last 
    Move.create :game_id => moved_piece.game.id, :piece_id => moved_piece.id, :x_coord => moved_piece.x_coord, :y_coord => moved_piece.y_coord
  end

  def self.piece_types
    %w(Pawn Rook Bishop Knight Queen King)
  end

  scope :pawns,   -> { where(piece_type: 'Pawn') }
  scope :rooks,   -> { where(piece_type: 'Rook') }
  scope :bishops, -> { where(piece_type: 'Bishop') }
  scope :knights, -> { where(piece_type: 'Knight') }
  scope :kings,   -> { where(piece_type: 'King') }
  scope :queens,  -> { where(piece_type: 'Queen') }

  New_Pieces = {
    "Pawn" => "Pawn", 
    "Knight" => "Knight",
    "Bishop" => "Bishop",
    "Rook" => "Rook",
    "Queen" => "Queen"
  }

  def move_valid?(new_x,new_y)
  end  

  def move_to!(new_x, new_y)
    # return a code or symbol
    # valid_move, invalid move, capture / reload game
    # need en passant
    destn_piece = self.game.square_occupied(new_x, new_y).first
    prev_move = self.game.pieces.where(:x_coord => self.x_coord, :y_coord => self.y_coord, :color => self.color).first
    unless destn_piece.nil?
      destn_piece.update_attributes(:x_coord => nil, :y_coord => nil)
    end

    if self.piece_type == "King" && self.game.castle?(new_x, self.color)
      if new_x > self.x_coord 
        rook = self.game.pieces.where(:x_coord => 7, :y_coord => self.y_coord).first
        rook.update_attributes(:x_coord => new_x - 1)
        self.create_move!
      else
        rook = self.game.pieces.where(:x_coord => 0, :y_coord => self.y_coord).first
        rook.update_attributes(:x_coord => new_x + 1)
        self.create_move!
      end

      self.update(:x_coord => new_x, :y_coord => new_y)
      return :castle
    elsif self.piece_type == "Pawn" && self.en_passant?(new_x, new_y)
      if self.color == "white"
        operation = -1
      else
        operation = 1
      end
      check_y = new_y + operation
      behind_piece = self.game.square_occupied(new_x, check_y).first
      behind_piece.update_attributes(:x_coord => nil, :y_coord => nil)
      self.update(:x_coord => new_x, :y_coord => new_y)
      self.create_move!
      return :reload
    end

    old_x = self.x_coord
    old_y = self.y_coord
    self.update(:x_coord => new_x, :y_coord => new_y)

    if self.game.in_check?(self.color)
      unless destn_piece.nil?
        destn_piece.update_attributes(:x_coord => new_x, :y_coord => new_y)
      end

      self.update_attributes(:x_coord => old_x, :y_coord => old_y)
      return :invalid_move
    elsif self.piece_type == "Pawn" && self.y_coord == 0 || self.y_coord == 7
      self.create_move!
      return :pawn_promote
    elsif destn_piece.nil?
      self.create_move!
      return :valid_move
    else 
      self.create_move!
      return :reload
    end
  end

  def pawn_promotion?
    self.piece_type == "Pawn" && self.y_coord == 0 || self.y_coord == 7
  end   



end


