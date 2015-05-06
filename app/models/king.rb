class King < Piece	
	def move_valid?(new_x, new_y)	
   # game cannot be obstructed if the king can castle

    return false if self.game.is_obstructed?([x_coord, y_coord], [new_x,new_y])
		# king moves one square in any direction
		king_castle?(new_x, new_y) ||
		valid_vertical_move?(new_x, new_y) 	 || 
		valid_horizontal_move?(new_x, new_y) ||
		valid_diagonal_move?(new_x, new_y)
	end

		def king_castle?(new_x, new_y)
		if self.game.castle?(new_x, self.color)
			if x_within_two?(new_x) && same_y?(new_y)
				return true
			else
				return false
			end
		end
		return false
	end

	private 

	def valid_vertical_move?(new_x, new_y)
		y_within_one?(new_y) if same_x?(new_x)
	end

	def valid_horizontal_move?(new_x, new_y)
		x_within_one?(new_x) if same_y?(new_y)
	end

	def valid_diagonal_move?(new_x, new_y)
		x_within_one?(new_x) && y_within_one?(new_y) 
	end	

	def same_x?(new_x)
		new_x == x_coord
	end

	def same_y?(new_y)
		new_y == y_coord
	end

	def y_within_one?(new_y)
		(new_y - y_coord).abs == 1 
	end

	def x_within_one?(new_x)
		(new_x - x_coord).abs == 1 
	end

	def x_within_two?(new_x)
		(new_x - x_coord).abs == 2
	end

end
