class King < Piece	
	def move_valid?(new_x, new_y)	
		# king moves one square in any direction
		valid_vertical_move?(new_x, new_y) 	 || 
		valid_horizontal_move?(new_x, new_y) ||
		valid_diagonal_move?(new_x, new_y)	
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
end
