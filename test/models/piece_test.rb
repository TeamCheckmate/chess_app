require 'test_helper'
# require 'pry'

class PieceTest < ActiveSupport::TestCase

  test "king_move_valid" do
	game = create_pieceless_game
	king = game.pieces.create(x_coord: 2, y_coord: 2, piece_type: "King", color: "black")
  # rook = game.pieces.create(x_coord: 0, y_coord: 0, piece_type: "Rook", color: "black")

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
    rook = game.pieces.create(x_coord: 4, y_coord: 4, piece_type: "Rook", color: "black")
    king = game.pieces.create(x_coord: 0, y_coord: 0, piece_type: "King", color: "black")

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

  test "king castle" do
    game = create_pieceless_game
    king = game.pieces.create(x_coord: 3, y_coord: 0, piece_type: "King", color: "black")
    rook = game.pieces.create(x_coord: 0, y_coord: 0, piece_type: "Rook", color: "black")

    assert_equal true, king.game.castle?(1, "black")
    assert_equal true, rook.move_valid?(2,0)
  end

test "white en passant" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,1], game, "Pawn", "white")
    p3 = create_piece([3,7], game, "King", "black")
    p4 = create_piece([1,3], game, "Pawn", "black")

    p2.update_attributes(:x_coord => 0, :y_coord => 3)
    p2.create_move!

    assert_equal true, p4.en_passant?(0,2)

  end

 test "black en passant" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,4], game, "Pawn", "white")
    p3 = create_piece([3,7], game, "King", "black")
    p4 = create_piece([1,6], game, "Pawn", "black")

    p4.move_to!(1,4)

    assert_equal true, p2.en_passant?(1,5)
    p2.move_to!(1,5)
    assert_equal nil, p4.reload.x_coord
  end

  test "white not en passant" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,1], game, "Pawn", "white")
    p3 = create_piece([3,7], game, "King", "black")
    p4 = create_piece([2,3], game, "Pawn", "black")

    p2.update_attributes(:x_coord => 0, :y_coord => 3)
    p2.create_move!

    assert_equal false, p4.en_passant?(0,2)

  end

 test "black not en passant" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,4], game, "Pawn", "white")
    p3 = create_piece([3,7], game, "King", "black")
    p4 = create_piece([1,5], game, "Pawn", "black")

    p4.update_attributes(:x_coord => 1, :y_coord => 4)
    p4.create_move!

    assert_equal false, p4.en_passant?(1,5)

  end

  test "too many moves for en passant" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,4], game, "Pawn", "white")
    p3 = create_piece([3,7], game, "King", "black")
    p4 = create_piece([1,6], game, "Pawn", "black")

    p4.update_attributes(:x_coord => 1, :y_coord => 5)
    p4.create_move!
    p4.update_attributes(:x_coord => 1, :y_coord => 4)
    p4.create_move!

    assert_equal false, p2.en_passant?(1,5)

  end

  test "move to switch turn valid move" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,4], game, "Pawn", "white")
    p3 = create_piece([3,7], game, "King", "black")

    assert_equal "white", game.playerturn
    p2.move_to!(0,5)
    assert_equal "black", game.playerturn
  end

  test "threefold repetition king" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([3,7], game, "King", "black")

    # start from original position
    p1.move_to!(3,1)
    assert_not p1.threefold_repetition?(3,0)

    p1.move_to!(3,0)  #second time on original position
    p1.move_to!(3,1)
    assert_equal true, p1.threefold_repetition?(3,0)

    p2.move_to!(3,6)
    p2.move_to!(4,6)

    # repetition square (3,2)
    p1.move_to!(3,2)  # => first time on 3,2
    p1.move_to!(3,3)  
    assert_not p1.threefold_repetition?(3,2)

    p1.move_to!(3,2)  # => second time on 3,2
    p1.move_to!(4,2)
    p2.move_to!(4,7)

    assert_equal true, p1.threefold_repetition?(3,2)
  end

  test "threefold repetition bishop" do
    game = create_pieceless_game
    w_k = create_piece([3,0], game, "King", "white")
    b_k = create_piece([3,7], game, "King", "black")
    w_b = create_piece([2,0], game, "Bishop", "white")

    # start from original position
    w_b.move_to!(1,1)
    assert_not w_b.threefold_repetition?(2, 0)

    w_b.move_to!(2,0)  # second time on original position
    w_b.move_to!(1,1)
    assert_equal true, w_b.threefold_repetition?(2,0)

    # repetition square (2,2)
    w_b.move_to!(2,2)  # => first time on 2,2
    w_b.move_to!(1,3)
    w_k.move_to!(2,0)
    w_b.move_to!(2,2)  # => second time on 2,2
    b_k.move_to!(3,6)
    w_b.move_to!(3,1)
    assert_equal true, w_b.threefold_repetition?(2,2)
  end

  test "threefold repetition rook" do
    game = create_pieceless_game
    w_k = create_piece([3,0], game, "King", "white")
    b_k = create_piece([3,7], game, "King", "black")
    b_r = create_piece([0,7], game, "Rook", "black")

    # start from original position
    b_r.move_to!(0,6)
    assert_not b_r.threefold_repetition?(0, 7)

    b_r.move_to!(0,7)
    b_r.move_to!(0,6)
    assert_equal true, b_r.threefold_repetition?(0,7)

    b_r.move_to!(0,5)
    b_r.move_to!(0,4)
    w_k.move_to!(3,1)
    b_r.move_to!(0,5)
    b_r.move_to!(0,4)
    assert_equal true, b_r.threefold_repetition?(0,5)
  end

  test "threefold repetition knight" do
    game = create_pieceless_game
    w_k = create_piece([3,0], game, "King", "white")
    b_k = create_piece([3,7], game, "King", "black")
    w_n = create_piece([1,0], game, "Knight", "white")

    # start from original position
    w_n.move_to!(3,1)
    assert_not w_n.threefold_repetition?(1,0)

    w_n.move_to!(1,0)
    w_n.move_to!(3,1)

    assert_equal true, w_n.threefold_repetition?(1,0)
  end

  test "threefold repetition pawn" do
    game = create_pieceless_game
    w_k = create_piece([3,0], game, "King", "white")
    b_k = create_piece([3,7], game, "King", "black")
    w_p = create_piece([1,1], game, "Pawn", "white")

    assert_not w_p.threefold_repetition?(1,2)
  end

  test "threefold repetition queen" do
    game = create_pieceless_game
    w_k = create_piece([3,0], game, "King", "white")
    b_k = create_piece([3,7], game, "King", "black")
    w_q = create_piece([4,0], game, "Queen", "white")

     # start from original position
    w_q.move_to!(4,1)
    assert_not w_q.threefold_repetition?(4,0)

    w_q.move_to!(4,0)
    w_q.move_to!(5,1)

    assert_equal true, w_q.threefold_repetition?(4,0)
  end

  test "create positions" do 
    game = FactoryGirl.create(:game)
    p = game.pieces.where(:x_coord => 4, :y_coord => 1).first
    p.move_to!(4,2)
    assert_equal 64, game.positions.count
  end
end
