require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  
  test "list available games" do
    user = FactoryGirl.create(:user)
    game = Game.create(:white_player_id => user.id)

    available_games = Game.where(:black_player_id => nil)

    assert_equal 1, available_games.count
    get :index
    assert_response :success
  end

end
