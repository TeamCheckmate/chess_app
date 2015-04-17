require 'test_helper'

class PieceTest < ActiveSupport::TestCase

  test "king_move_valid" do
	game = create_pieceless_game
	king = game.pieces.new(x_coord: 2, y_coord: 2, piece_type: "King")

	# valid moves, king moves one square in any direction
	[:+,:-].each do |operation|
		# vertically 
		destination = [king.x_coord.send(operation,1),king.y_coord]
		assert_equal true, king.move_valid?(destination)

		# horizontally 
		destination = [king.x_coord, king.y_coord.send(operation,1)]
		assert_equal true, king.move_valid?(destination)

		# diagonally 
		[:+,:-].each do |operation_2|
			destination = [king.x_coord.send(operation, 1), king.y_coord.send(operation_2, 1)]
			assert_equal true, king.move_valid?(destination)
		end
	end

	# invalid move
	destination = [5,6]
	assert_equal false, king.move_valid?(destination)

	# destination same as original coordinate
	destination = [2,2]
	assert_equal false, king.move_valid?(destination)
  end
end
