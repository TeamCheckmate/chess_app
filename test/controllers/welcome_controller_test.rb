require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  
  test "list available games" do
    @available_games = Game.where(:black_player_id => nil)
    get :index
    assert_response :success
  end

end
