require 'test_helper'

class PieceTest < ActiveSupport::TestCase

  test "king_move_valid" do
	game = create_pieceless_game
	king = game.pieces.new(x_coord: 2, y_coord: 2, piece_type: "King")

	# valid moves, king moves one square in any direction
	[:+,:-].each do |operation|
		# vertically 
		assert_equal true, king.move_valid?(king.x_coord.send(operation,1),king.y_coord)

		# horizontally 
		assert_equal true, king.move_valid?(king.x_coord, king.y_coord.send(operation,1))

		# diagonally 
		[:+,:-].each do |operation_2|
			assert_equal true, king.move_valid?(king.x_coord.send(operation, 1), king.y_coord.send(operation_2, 1))
		end
	end

	# invalid move
	assert_equal false, king.move_valid?(5,6)

	# destination same as original coordinate
	assert_equal false, king.move_valid?(2,2)
  end
end
