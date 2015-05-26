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

    title = "Test"
  	assert_difference 'Game.count' do 
  		post :create, {:game => {:title => title}}
  	end

    game = Game.last
    assert_equal user, game.white_player
    assert_equal title, game.title 
  	assert_redirected_to game_path(Game.last)
  end

  test "join game" do
    user = FactoryGirl.create(:user)
    user2= FactoryGirl.create(:user)
    game = Game.create(:white_player => user)

    sign_in user2

    assert_no_difference 'Game.count' do
      patch :join, :id => game.id
    end
    puts game.inspect
    assert_equal user2, game.reload.black_player
    assert_redirected_to game_path(game)
  end

  

end
