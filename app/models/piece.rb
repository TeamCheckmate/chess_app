class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  self.inheritance_column = :piece_type

  validate :x_coord, :y_coord, presence: true

  def self.piece_types
    %w(Pawn Rook Bishop Knight Queen King)
  end

  scope :pawns,   -> { where(piece_type: 'Pawn') }
  scope :rooks,   -> { where(piece_type: 'Rook') }
  scope :bishops, -> { where(piece_type: 'Bishop') }
  scope :knights, -> { where(piece_type: 'Knight') }
  scope :kings,   -> { where(piece_type: 'King') }
  scope :queens,  -> { where(piece_type: 'Queen') }

  def move_valid?(new_x,new_y)
  end  

  def move_to!(new_x, new_y)
    # return a code or symbol
    # valid_move, invalid move, capture / reload game
    destn_piece = self.game.square_occupied(new_x, new_y).first 
    unless destn_piece.nil?
      destn_piece.update_attributes(:x_coord => nil, :y_coord => nil)
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
    else
      if destn_piece.nil?
        return :valid_move
      else
        return :reload
      end
    end
  end
end


