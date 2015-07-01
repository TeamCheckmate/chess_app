class AddPieceDataToPosition < ActiveRecord::Migration
  def change
  	add_column :positions, :piece_data, :hstore
  end
end
