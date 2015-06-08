class AddTurnColumnToPosition < ActiveRecord::Migration
  def change
  	add_column :positions, :turn, :integer
  end
end
