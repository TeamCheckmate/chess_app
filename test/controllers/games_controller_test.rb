require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  test "render_new" do
  	user = FactoryGirl.create(:user)
  	sign_in user
  	get :new
  	assert_response :success
  end
end
