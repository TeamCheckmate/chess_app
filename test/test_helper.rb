ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  setup do 
  	DatabaseCleaner.clean
  end
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...

  # Add more helper methods to be used by all tests here...

end

class ActionController::TestCase
	include Devise::TestHelpers
end

def create_pieceless_game
  game = FactoryGirl.create(:game)
  game.pieces.destroy_all
  game
end

# This method can create a piece by simply inputing a desired coordinate [x,y] and a game 
def create_piece(coord, game, type=nil, color=nil)
  piece = Piece.create!(x_coord: coord[0], y_coord: coord[1], piece_type: type, game: game, color: color)
  piece 
end

def move_piece(piece, x, y)
  put :update, :id => piece.id, :piece => {:x_coord => piece.reload.x_coord + x, :y_coord => piece.reload.y_coord + y}
end
