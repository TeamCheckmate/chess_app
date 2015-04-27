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
    destn_piece = self.game.square_occupied(new_x, new_y) 
    if destn_piece.empty?
      return destn_piece.first
    else 
      destn_piece.first.update(:x_coord => nil, :y_coord => nil)
      return destn_piece.first
    end
  end
end


