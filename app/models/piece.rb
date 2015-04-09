class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  self.inheritance_column = :piece_type

  def self.piece_types
    %w(Pawn Rook Bishop Knight Queen King)
  end

  scope :pawns,   -> { where(piece_type: 'Pawn') }
  scope :rooks,   -> { where(piece_type: 'Rook') }
  scope :bishops, -> { where(piece_type: 'Bishop') }
  scope :knights, -> { where(piece_type: 'Knight') }
  scope :kings,   -> { where(piece_type: 'King') }
  scope :queens,  -> { where(piece_type: 'Queen') }
 
end

class Pawn < Piece; end
class Rook < Piece; end
class Bishop < Piece; end
class Knight < Piece; end
class King < Piece; end
class Queen < Piece; end



