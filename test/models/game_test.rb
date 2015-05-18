require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "populate pieces" do
    # u = User.create(:email => '123@gmail.com', :password => 'password', :password_confirmation => 'password' )
    # u = User.create(:email => '456@gmail.com', :password => 'password', :password_confirmation => 'password' )
    # u1 = FactoryGirl.create(:user)
    # u2 = FactoryGirl.create(:user)
    # g = Game.create(:white_player_id => u1.id, :black_player_id => u2.id)
    g = FactoryGirl.build(:game)
    # g.populate_the_pieces!
    assert_equal 0, g.pieces.count
    g.save
    assert_equal 32, g.pieces.count
    assert_equal 4, g.pieces.where(:piece_type => "Rook").count
    assert_equal 4, g.pieces.where(:piece_type => "Knight").count
    assert_equal 4, g.pieces.where(:piece_type => "Bishop").count
    assert_equal 2, g.pieces.where(:piece_type => "Queen").count
    assert_equal 2, g.pieces.where(:piece_type => "King").count
    assert_equal 16, g.pieces.where(:piece_type => "Pawn").count
  end


  test "is_obstructed?_vertical_true" do
    game = create_pieceless_game
    p1 = create_piece([3,1], game, "Pawn")
    p2 = create_piece([3,2], game)
    assert_equal true, game.is_obstructed?([3,1], [3,6])
  end

  test "is_obstructed?_vertical_false" do
    game = create_pieceless_game
    
    p1 = create_piece([3,1], game, "Pawn")
    
    assert_equal false, game.is_obstructed?([3,1], [3,5])
  end

  test "is_obstructed?_vertical_same_coord_error" do
    game = create_pieceless_game
    
    assert RuntimeError do
     game.is_obstructed?([3,1], [3,1])
    end
  end

  test "is_obstructed?_horizontal_true" do
    game = create_pieceless_game
    p1 = create_piece([1,3], game, "Pawn")
    p2 = create_piece([2,3],game,"Bishop")
    assert_equal true, game.is_obstructed?([1,3], [4,3])
  end 

  test "is_obstructed?_horizontal_false" do
    game = create_pieceless_game
    p1 = create_piece([1,3], game, "Pawn")
    assert_equal false, game.is_obstructed?([1,3], [4,3])
  end   

  test "is_obstructed?_horizontal_error" do
    game = create_pieceless_game
    p1 = create_piece([3,3], game, "Pawn")
    
    assert RuntimeError do
     game.is_obstructed?([3,3], [3,3])
    end
  end 

  test "is_obstructed?_diagonal_true_x_y_increase" do
    game = create_pieceless_game
    
    p1 = create_piece([1,1], game, "Pawn")
    p2 = create_piece([2,2],game, "Bishop")
    assert_equal true, game.is_obstructed?([1,1], [4,4])
  end 

  test "is_obstructed?_diagonal_true_x_increase_y_decrease" do
    game = create_pieceless_game
    
    p1 = create_piece([2,5], game, "Pawn")
    p2 = create_piece([3,4],game, "Bishop")
    assert_equal true, game.is_obstructed?([2,5], [4,3])
  end   

  test "is_obstructed?_diagonal_true_x_decrease_y_increase" do
    game = create_pieceless_game
    
    p1 = create_piece([6,1], game, "Pawn")
    p2 = create_piece([5,2], game, "Bishop")
    assert_equal true, game.is_obstructed?([6,1], [3,4])
  end 

  test "is_obstructed?_diagonal_true_x_decrease_y_decrease" do
    game = create_pieceless_game
    
    p1 = create_piece([5,6], game, "Pawn")
    p2 = create_piece([4,5], game, "Bishop")
    assert_equal true, game.is_obstructed?([5,6], [1,2]) 
  end

  test "is_obstructed?_random_input_error" do
    game = create_pieceless_game
    
    p1 = create_piece([3,3], game, "Pawn")
    
    assert RuntimeError do
     game.is_obstructed?([3,3], [6,7])
    end
  end

  test "is_obstructed?same_color" do
    game = create_pieceless_game
    p1 = create_piece([3,3], game, "Pawn", "white")
    p2 = create_piece([6,6], game, "Pawn", "white")

    assert_equal true, game.is_obstructed?([3,3], [6,6]) 
  end

  test "is_obstructed?different_color" do
    game = create_pieceless_game
    p1 = create_piece([3,3], game, "Bishop", "white")
    p2 = create_piece([6,6], game, "Queen", "black")

    assert_equal false, game.is_obstructed?([3,3], [6,6]) 
  end

  test "in_check" do
    game = create_pieceless_game
    p1 = create_piece([3,3], game, "King", "white")
    p2 = create_piece([6,6], game, "Queen", "black")

    assert_equal true, game.in_check?("white")
  end

  test "not_in_check" do
    game = create_pieceless_game
    p1 = create_piece([3,3], game, "King", "white")
    p2 = create_piece([7,6], game, "Queen", "black")

    assert_equal false, game.in_check?("white")
  end


  test "checkmate true" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([0,6], game, "Queen", "black")
    p3 = create_piece([7,7], game, "King", "black")
    p4 = create_piece([1,6], game, "Rook", "black")
    assert_equal true, game.check_mate?

  end

    test "checkmate false king move" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([0,6], game, "Queen", "black")
    p3 = create_piece([7,7], game, "King", "black")
    assert_equal false, game.check_mate?

  end

  test "checkmate false obstruction" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([0,6], game, "Queen", "black")
    p3 = create_piece([7,7], game, "King", "black")
    p4 = create_piece([1,6], game, "Rook", "black")
    p5 = create_piece([4,2], game, "Rook", "white")
    assert_equal false, game.check_mate?

  end

  test "checkmate true diagonal" do 
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([6,6], game, "Queen", "black")
    p3 = create_piece([7,7], game, "King", "black")
    p4 = create_piece([0,1], game, "Pawn", "white")
    p5 = create_piece([1,0], game, "Bishop", "white")
    assert_equal true, game.check_mate?
  end

  test "checkmate false block diagonal" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([6,6], game, "Queen", "black")
    p3 = create_piece([7,7], game, "King", "black")
    p4 = create_piece([0,1], game, "Pawn", "white")
    p5 = create_piece([1,0], game, "Rook", "white")
    assert_equal false, game.check_mate?
  end

  test "checkmate true pinned" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([6,6], game, "Queen", "black")
    p3 = create_piece([7,7], game, "King", "black")
    p4 = create_piece([0,1], game, "Pawn", "white")
    p5 = create_piece([1,0], game, "Rook", "white")
    p6 = create_piece([5,0], game, "Rook", "black")
    assert_equal true, game.check_mate?
  end

  test "checkmate false take piece" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([6,6], game, "Queen", "black")
    p3 = create_piece([7,7], game, "King", "black")
    p4 = create_piece([0,1], game, "Pawn", "white")
    p5 = create_piece([1,0], game, "Bishop", "white")
    p6 = create_piece([6,3], game, "Rook", "white")
    assert_equal false, game.check_mate?
  end

  test "checkmate true diagonal next to king" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([1,1], game, "Queen", "black")
    p3 = create_piece([2,2], game, "King", "black")
    p4 = create_piece([0,1], game, "Pawn", "white")
    p5 = create_piece([1,0], game, "Bishop", "white")
    assert_equal true, game.check_mate?
  end

  test "checkmate true pinned cannot take" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([1,1], game, "Queen", "black")
    p3 = create_piece([2,2], game, "King", "black")
    p4 = create_piece([0,1], game, "Pawn", "white")
    p5 = create_piece([1,0], game, "Rook", "white")
    p6 = create_piece([7,0], game, "Rook", "black")
    assert_equal true, game.check_mate?
  end

  test "checkmate true two knights" do
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([1,2], game, "Knight", "black")
    p3 = create_piece([0,2], game, "King", "black")
    p4 = create_piece([2,2], game, "Knight", "black")
    assert_equal true, game.check_mate?
  end

  test "bishop checkmate false" do 
    game = create_pieceless_game
    p1 = create_piece([0,0], game, "King", "white")
    p2 = create_piece([3,7], game, "Queen", "black")
    p3 = create_piece([4,7], game, "King", "black")
    p4 = create_piece([4,6], game, "Pawn", "black")
    p5 = create_piece([5,6], game, "Pawn", "black")
    p6 = create_piece([5,7], game, "Rook", "black")
    p7 = create_piece([0,5], game, "Bishop", "black")
    p8 = create_piece([1,4], game, "Bishop", "white")
    assert_equal false, game.check_mate?

  end

  test "white can castle" do
   game = create_pieceless_game
   p1 = create_piece([3,0], game, "King", "white")
   p2 = create_piece([0,0], game, "Rook", "white")
   p3 = create_piece([3,7], game, "King", "black")

   assert_equal true, game.castle?(1, "white")
  end

  test "white cannot castle no rook" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,0], game, "Rook", "white")
    p3 = create_piece([3,7], game, "King", "black")

   assert_equal false, game.castle?(5, "white")

  end

  test "white cannot castle in check" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,0], game, "Rook", "white")
    p3 = create_piece([3,7], game, "King", "black")
    p4 = create_piece([2,5], game, "Rook", "black")

   assert_equal false, game.castle?(1, "white")

  end

   test "white cannot castle" do
    game = create_pieceless_game
    p1 = create_piece([3,0], game, "King", "white")
    p2 = create_piece([0,0], game, "Rook", "white")
    p3 = create_piece([3,7], game, "King", "black")
    p4 = create_piece([2,0], game, "Knight", "white")

   assert_equal false, game.castle?(1, "white")

  end

  
   test "black stalemate" do
    game = create_pieceless_game
    p1 = create_piece([7,0], game, "King", "white")
    p2 = create_piece([1,3], game, "Rook", "white")
    p3 = create_piece([0,0], game, "King", "black")
    p4 = create_piece([3,1], game, "Rook", "white")

   assert_equal false, game.not_stalemate?("black")

  end




end
