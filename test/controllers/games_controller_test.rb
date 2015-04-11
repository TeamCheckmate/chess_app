require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "render_new" do
  	user = FactoryGirl.create(:user)
  	sign_in user
  	get :new
  	assert_response :success
  end

  test "create_new_game" do
    puts User.all.inspect
  	user = FactoryGirl.create(:user)
  	sign_in user

  	assert_difference 'Game.count' do 
  		post :create, {:game => {:black_player_id => nil}}
  	end

  	assert_redirected_to game_path(Game.last)
  end

  test "update game - let user join game" do
    user = FactoryGirl.create(:user)
    game = FactoryGirl.create(:game)
    sign_in user

    assert_no_difference 'Game.count' do
      put :update, {:id => game.id, :game => {:black_player_id => user.id}}
    end

    assert_redirected_to game_path
  end

end
