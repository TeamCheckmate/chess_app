class Position < ActiveRecord::Base
	belongs_to :game

	store_accessor :piece_data
end


