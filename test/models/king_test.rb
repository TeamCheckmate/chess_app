require 'test_helper'

class KingTest < ActiveSupport::TestCase

test "king move to castle" do
    game = create_pieceless_game
    king = game.pieces.create(x_coord: 4, y_coord: 0, piece_type: "King", color: "white")
    rook = game.pieces.create(x_coord: 7, y_coord: 0, piece_type: "Rook", color: "white")
    king2 = game.pieces.create(x_coord: 0, y_coord: 7, piece_type: "King", color: "black")

    assert_equal true, game.castle?(6, "white")
    assert_equal true, king.move_valid?(6,0)
  end


end
