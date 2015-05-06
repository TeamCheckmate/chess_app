  require 'test_helper'
  require 'pry'

class RookTest < ActiveSupport::TestCase

  test "king castle" do
    game = create_pieceless_game
    king = game.pieces.create(x_coord: 3, y_coord: 0, piece_type: "King", color: "black")
    rook = game.pieces.create(x_coord: 7, y_coord: 0, piece_type: "Rook", color: "black")
    king2 = game.pieces.create(x_coord: 0, y_coord: 7, piece_type: "King", color: "white")

    king.move_to!(5, 0)
    assert_equal 4, rook.reload.x_coord
  end

end