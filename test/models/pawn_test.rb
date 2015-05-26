require 'test_helper'

class PawnTest < ActiveSupport::TestCase

  test "white_pawn_move_valid" do
  game = create_pieceless_game
  pawn = game.pieces.create(x_coord: 2, y_coord: 1, piece_type: "Pawn", color: "white")
  # black_pawn = game.pieces.new(x_coord: 2, y_coord: 6, piece_type: "Pawn", color: "black")

  # valid moves, king moves one square in any direction
  operation = :+
    # vertically 
    assert_equal true, pawn.move_valid?(pawn.x_coord,pawn.y_coord.send(operation,1))

    # starting move 
    assert_equal true, pawn.move_valid?(pawn.x_coord,pawn.y_coord.send(operation,2))

    # diagonally
    assert_equal false, pawn.move_valid?(pawn.x_coord.send(operation,1),pawn.y_coord.send(operation,1))

  # invalid move
  assert_equal false, pawn.move_valid?(4,4)
  assert_equal false, pawn.move_valid?(3,1)

  # destination same as original coordinate
  assert_equal false, pawn.move_valid?(2,1)
  end

  test "black_pawn_move_valid" do
    game = create_pieceless_game
    pawn = game.pieces.create(x_coord: 2, y_coord: 6, piece_type: "Pawn", color: "black")

    # valid moves, king moves one square in any direction
    operation = :-
      # vertically 
      assert_equal true, pawn.move_valid?(pawn.x_coord,pawn.y_coord.send(operation,1))

      # starting move 
      assert_equal true, pawn.move_valid?(pawn.x_coord,pawn.y_coord.send(operation,2))

      # diagonally
      assert_equal false, pawn.move_valid?(pawn.x_coord.send(operation,1),pawn.y_coord.send(operation,1))

    # invalid move
    assert_equal false, pawn.move_valid?(4,4)
    assert_equal false, pawn.move_valid?(3,6)

    # destination same as original coordinate
    assert_equal false, pawn.move_valid?(2,6)
  end

  test "is_obstructed?pawn" do
    game = create_pieceless_game
    
    p_w = Piece.create!(x_coord: 1, y_coord: 1, color: "white", piece_type: "Pawn", game: game)
    p_b = Piece.create!(x_coord: 1, y_coord: 2, color: "black", piece_type: "Pawn", game: game)

    assert_equal true, game.is_obstructed?([1,1], [1,3]) 

  end

  test "pawn diagonal" do
    game = create_pieceless_game

    p_w = Piece.create!(x_coord: 1, y_coord: 1, color: "white", piece_type: "Pawn", game: game)
    p_b = Piece.create!(x_coord: 0, y_coord: 2, color: "black", piece_type: "Pawn", game: game)

    assert_equal true, p_w.move_valid?(0,2)
  end


end
