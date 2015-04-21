require 'test_helper'

class KnightTest < ActiveSupport::TestCase

  test "knight_move_valid" do
  game = create_pieceless_game
  knight = game.pieces.new(x_coord: 2, y_coord: 2, piece_type: "Knight")

  # valid moves, king moves one square in any direction
  [:+,:-].each do |operation|
    # vertically 
    assert_equal true, knight.move_valid?(knight.x_coord.send(operation,1),knight.y_coord.send(operation,2))

    # horizontally 
    assert_equal true, knight.move_valid?(knight.x_coord.send(operation,2),knight.y_coord.send(operation,1))

    # diagonally 
  end

  # invalid move
  assert_equal false, knight.move_valid?(4,4)

  # destination same as original coordinate
  assert_equal false, knight.move_valid?(2,2)
  end
end
