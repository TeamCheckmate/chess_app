require 'test_helper'

class MoveTest < ActiveSupport::TestCase
  test "create move" do

    game = create_pieceless_game
    p1 = create_piece([3,3], game, "King", "white")
    p2 = create_piece([7,6], game, "Queen", "black")

    p2.update_attributes(:x_coord => 0, :y_coord => 7)

    assert_equal 1, game.moves.count
  end
end
