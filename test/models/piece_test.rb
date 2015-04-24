require 'test_helper'

class PieceTest < ActiveSupport::TestCase

  test "king_move_valid" do
	game = create_pieceless_game
	king = game.pieces.create(x_coord: 2, y_coord: 2, piece_type: "King")

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

  test "queen_move_valid" do
    game = create_pieceless_game
    queen = game.pieces.create(x_coord: 4, y_coord: 4, piece_type: "Queen")

    [:+,:-].each do |operation|
      # horizontal
      assert_equal true, queen.move_valid?(queen.x_coord.send(operation,1),queen.y_coord)

      # vertical
      assert_equal true, queen.move_valid?(queen.x_coord, queen.y_coord.send(operation,1))

      # diagonal
      [:+,:-].each do |operation_2|
        assert_equal true, queen.move_valid?(queen.x_coord.send(operation, 1), queen.y_coord.send(operation_2, 1))
      end
    end

    # invalid move
    assert_equal false, queen.move_valid?(0,2)

    # destination same as original coordinate
    assert_equal false, queen.move_valid?(4,4)
  end

  test "rook_move_valid" do
    game = create_pieceless_game
    rook = game.pieces.create(x_coord: 4, y_coord: 4, piece_type: "Rook")

    [:+,:-].each do |operation|
      # horizontal
      assert_equal true, rook.move_valid?(rook.x_coord.send(operation,1),rook.y_coord)

      # vertical
      assert_equal true, rook.move_valid?(rook.x_coord, rook.y_coord.send(operation,1))

      # diagonal
      [:+,:-].each do |operation_2|
              assert_equal false, rook.move_valid?(rook.x_coord.send(operation, 1), rook.y_coord.send(operation_2, 1))
      end
    end

    # invalid move
    assert_equal false, rook.move_valid?(0,2)

    # destination same as original coordinate
    assert_equal false, rook.move_valid?(4,4)
  end
 
  test "bishop_move_valid" do
    game = create_pieceless_game
    bishop = game.pieces.create(x_coord: 4, y_coord: 4, piece_type: "Bishop")

    [:+,:-].each do |operation|
      # horizontal
      assert_equal false, bishop.move_valid?(bishop.x_coord.send(operation,1),bishop.y_coord)

      #vertical
      assert_equal false, bishop.move_valid?(bishop.x_coord, bishop.y_coord.send(operation,1))

      # diagonal
      [:+,:-].each do |operation_2|
              assert_equal true, bishop.move_valid?(bishop.x_coord.send(operation, 1), bishop.y_coord.send(operation_2, 1))
      end
    end

    # invalid move
    assert_equal false, bishop.move_valid?(0,2)

    # destination same as original coordinate
    assert_equal false, bishop.move_valid?(4,4)
  end
end
