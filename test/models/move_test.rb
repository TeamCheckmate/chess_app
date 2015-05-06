require 'test_helper'

class MoveTest < ActiveSupport::TestCase
  test "create move" do

    game = create_pieceless_game
    p1 = create_piece([3,3], game, "King", "white")
    p1 = create_piece([0,0], game, "King", "black")
    p2 = create_piece([7,6], game, "Queen", "black")

    p2.move_to!(7, 7)

    assert_equal 1, game.moves.count
  end
end
