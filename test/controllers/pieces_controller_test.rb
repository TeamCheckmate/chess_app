require 'test_helper'

class PiecesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "render_piece" do
    user = FactoryGirl.create(:user)
    sign_in user
    game = FactoryGirl.create(:game)
    piece = game.pieces.first
    get :show, id: piece.id
    assert_response :success
  end

  test "update_piece" do
    user = FactoryGirl.create(:user)
    sign_in user
    game = FactoryGirl.create(:game)
    piece = game.pieces.first
    put :update, id: piece.id, :piece => {x_coord: 3, y_coord: 4}
    assert_response :success
  end

  test "destroy_piece" do
    user = FactoryGirl.create(:user)
    game = FactoryGirl.create(:game)
    sign_in user

  
    post :destroy, {:id => game.pieces.last.id}
    assert_equal 31, game.pieces.count

  end

end
