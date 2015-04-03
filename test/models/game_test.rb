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
end
