class AddTurnColumnToGameTable < ActiveRecord::Migration
  def change
  	add_column :games, :turn, :string
  end
end
