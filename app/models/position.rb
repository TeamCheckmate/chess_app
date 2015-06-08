class Position < ActiveRecord::Base
	belongs_to :game
	belongs_to :piece
end


