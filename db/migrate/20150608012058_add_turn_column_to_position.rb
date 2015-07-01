class AddTurnColumnToPosition < ActiveRecord::Migration
  def change
  	add_column :positions, :turn_number, :integer
  end
end
