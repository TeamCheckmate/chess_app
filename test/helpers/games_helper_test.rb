require 'test_helper'

class GamesHelperTest < ActionView::TestCase
  test "returns_an_image" do
    @game = Game.create
    @pieces = @game.pieces
    piece = @pieces.where(:x_coord => 0, :y_coord => 0).first
    assert_equal chess_piece(0,0), image_tag(piece.image_name)
  end

  test "returns_nil_if_piece_does_not_exist" do
    @game = Game.create
    @pieces = @game.pieces
    #piece = @pieces.where(:x_coord => 0, :y_coord => 0).first
    assert_equal chess_piece(4,4), nil
  end
end
