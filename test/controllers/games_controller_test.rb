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
  	user = FactoryGirl.create(:user)
  	sign_in user

  	assert_difference 'Game.count' do 
  		post :create, {:game => {:black_player_id => nil}}
  	end

  	assert_redirected_to game_path(Game.last)
  end

end
