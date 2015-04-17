class King < Piece	
	def move_valid?(destn)	
		# destn accepts an array, [destn_x_coord, destn_y_coord]
		destn_x, destn_y = set_destn(destn)

		if (destn_x == x_coord)
			destn_y == y_coord + 1 || destn_y == y_coord - 1 
		elsif (destn_y == y_coord)
			destn_x == x_coord + 1 || destn_x == x_coord - 1
		else
			(destn_x - x_coord).abs == 1 && (destn_y - y_coord).abs == 1 
		end
	end
end
