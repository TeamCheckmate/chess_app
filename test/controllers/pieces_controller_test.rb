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

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 1, :y_coord => 1, :piece_type => 'Rook')
    put :update, id: piece.id, :piece => {x_coord: 3, y_coord: 1}
    assert_response :success
  end

  test "destroy_piece" do
    user = FactoryGirl.create(:user)
    game = FactoryGirl.create(:game)
    sign_in user

  
    post :destroy, {:id => game.pieces.last.id}
    assert_equal 31, game.pieces.count

  end

  test "updating_invalid_move" do
    user = FactoryGirl.create(:user)
    sign_in user

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 1, :y_coord => 1, :piece_type => 'Rook')
    put :update, id: piece.id, :piece => {x_coord: 3, y_coord: 2}

    assert_response :unprocessable_entity
    response = ActiveSupport::JSON.decode @response.body
    assert response["message"].present?
  end

end
