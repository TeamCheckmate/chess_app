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


end
