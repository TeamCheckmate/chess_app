class King < Piece
	def set_destn(destn)
		destn_x = destn[0]
		destn_y = destn[1]

		return  destn_x, destn_y
	end
	
	def move_valid(destn)
		destn_x, destn_y = set_destn(destn)

		if (destn_x - x_coord).abs == 1 && (destn_y - y_coord).abs == 1 
			true 
		else 
			false
		end
	end
end
