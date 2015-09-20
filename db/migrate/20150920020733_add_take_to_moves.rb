class AddTakeToMoves < ActiveRecord::Migration
  def change
    add_column :moves, :take, :boolean
  end
end
