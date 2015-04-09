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


  test "is_obstructed_vertical_true" do
    game = FactoryGirl.create(:game)
    game.pieces.destroy_all
    
    p1 = Piece.create(x_coord: 3, y_coord: 3, game: game)
    
    assert_equal true, game.is_obstructed(initial_x: 3, initial_y: 1, final_x: 3, final_y: 6)
  end

  test "is_obstructed_vertical_false" do
    game = FactoryGirl.create(:game)
    game.pieces.destroy_all
    
    p1 = Piece.create(x_coord: 0, y_coord: 0, game: game)
    
    assert_equal false, game.is_obstructed(initial_x: 3, initial_y: 1, final_x: 3, final_y: 6)
  end

  test "is_obstructed_vertical_same_coord_error" do
    game = FactoryGirl.create(:game)
    
    assert RuntimeError do
     game.is_obstructed(initial_x: 3, initial_y: 1, final_x: 3, final_y: 1)
    end
  end

  test "is_obstructed_horizontal_true" do
    game = FactoryGirl.create(:game)
    game.pieces.destroy_all
    
    p1 = Piece.create(x_coord: 0, y_coord: 0, game: game)
    
    assert_equal true, game.is_obstructed(initial_x: 1, initial_y: 3, final_x: 4, final_y: 3)
  end  
end
