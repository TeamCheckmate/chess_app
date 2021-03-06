require 'test_helper'
# require 'pry'

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
    piece4 = game.pieces.create(:x_coord => 0, :y_coord => 0, :piece_type => 'King', :color => "black")
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
    piece = game.pieces.create(:x_coord => 1, :y_coord => 1, :piece_type => 'Rook', :color => "black")
    piece4 = game.pieces.create(:x_coord => 0, :y_coord => 0, :piece_type => 'King', :color => "black")
    piece5 = game.pieces.create(:x_coord => 7, :y_coord => 7, :piece_type => 'King', :color => "white")
    put :update, id: piece.id, :piece => {x_coord: 3, y_coord: 2}
    assert_equal "#{piece.piece_type}: Invalid move!", flash[:alert] 
    response = ActiveSupport::JSON.decode @response.body
  end

  test "capture_method" do
    user = FactoryGirl.create(:user)
    sign_in user

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 1, :y_coord => 1, :piece_type => 'Rook', :color => "white")
    piece2 = game.pieces.create(:x_coord => 3, :y_coord => 1, :piece_type => 'Pawn', :color => "black")
    piece3 = game.pieces.create(:x_coord => 6, :y_coord => 6, :piece_type => 'King', :color => "white")
    piece4 = game.pieces.create(:x_coord => 0, :y_coord => 0, :piece_type => 'King', :color => "black")
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

  test "pawn capture" do
    user = FactoryGirl.create(:user)
    sign_in user

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 1, :y_coord => 1, :piece_type => 'Pawn', :color => "white")
    piece2 = game.pieces.create(:x_coord => 0, :y_coord => 2, :piece_type => 'Pawn', :color => "black")
    piece3 = game.pieces.create(:x_coord => 7, :y_coord => 7, :piece_type => 'King', :color => "white")
    piece4 = game.pieces.create(:x_coord => 0, :y_coord => 0, :piece_type => 'King', :color => "black")
    put :update, :id => piece.id, :piece => {:x_coord => 0, :y_coord => 2}
    assert_response :success
    assert_equal nil, piece2.reload.x_coord
  end

  test "pawn promote" do
    user = FactoryGirl.create(:user)
    sign_in user

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 0, :y_coord => 6, :piece_type => 'Pawn', :color => "white")
    piece2 = game.pieces.create(:x_coord => 7, :y_coord => 7, :piece_type => 'King', :color => "white")
    piece4 = game.pieces.create(:x_coord => 0, :y_coord => 0, :piece_type => 'King', :color => "black")
    put :update, :id => piece.id, :piece => {:x_coord => 0, :y_coord => 7}
    assert_response :partial_content
  end

  test "white castled" do
    user = FactoryGirl.create(:user)
    sign_in user

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 7, :y_coord => 0, :piece_type => 'Rook', :color => "white")
    piece2 = game.pieces.create(:x_coord => 3, :y_coord => 0, :piece_type => 'King', :color => "white")
    piece3 = game.pieces.create(:x_coord => 0, :y_coord => 7, :piece_type => 'King', :color => "black")

    # assert_equal true, piece2.move_valid?(5, 0)
    # assert_equal true, game.castle?(5, "white")
    assert_equal true, piece2.piece_type == "King" 
    assert_equal true, piece2.game.castle?(5, piece2.color)
    put :update, :id => piece2.id, :piece => {:x_coord => 5, :y_coord => 0}
    assert_equal 4, piece.reload.x_coord

  end

  test "white castle king side" do
    user = FactoryGirl.create(:user)
    sign_in user

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 0, :y_coord => 0, :piece_type => 'Rook', :color => "white")
    piece2 = game.pieces.create(:x_coord => 3, :y_coord => 0, :piece_type => 'King', :color => "white")
    piece3 = game.pieces.create(:x_coord => 7, :y_coord => 7, :piece_type => 'King', :color => "black")

    assert_equal true, piece2.game.castle?(1, piece2.color)
    put :update, :id => piece2.id, :piece => {:x_coord => 1, :y_coord => 0}
    assert_equal 2, piece.reload.x_coord

  end

  test "update piece type" do
    user = FactoryGirl.create(:user)
    sign_in user

    game = create_pieceless_game
    piece = game.pieces.create(:x_coord => 0, :y_coord => 0, :piece_type => 'Pawn', :color => "white")
    patch :change_piece_type, {:piece_id => piece.id, :piece_type => 'Queen'}
    piece = Piece.find(piece.id)
    assert_equal 'Queen', piece.piece_type
    assert_equal 'pieces/wq.png', piece.image_name
  end

end
