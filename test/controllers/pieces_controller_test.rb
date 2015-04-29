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
    piece = game.pieces.create(:x_coord => 1, :y_coord => 1, :piece_type => 'Rook', :color => "white")
    piece2 = game.pieces.create(:x_coord => 3, :y_coord => 3, :piece_type => 'King', :color => "white")
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

  test "capture_method" do
    user = FactoryGirl.create(:user)
    sign_in user

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 1, :y_coord => 1, :piece_type => 'Rook', :color => "white")
    piece2 = game.pieces.create(:x_coord => 3, :y_coord => 1, :piece_type => 'Pawn', :color => "black")
    piece3 = game.pieces.create(:x_coord => 6, :y_coord => 6, :piece_type => 'King', :color => "white")
    put :update, :id => piece.id, :piece => {:x_coord => 3, :y_coord => 1}
    assert_response :success
    assert_equal nil, piece2.reload.x_coord
  end

  test "block check" do
    user = FactoryGirl.create(:user)
    sign_in user
    game = create_pieceless_game
    p1 = create_piece([3,7], game, "King", "black")
    p2 = create_piece([6,4], game, "Bishop", "white")
    p3 = create_piece([5,6], game, "Pawn", "black")
    p3.update_attributes(:y_coord => 5)
    assert_equal false, game.in_check?("black")
  end

end
