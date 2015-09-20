class AddOldXOldYCastleToMoves < ActiveRecord::Migration
  def change
    add_column :moves, :old_x, :integer
    add_column :moves, :old_y, :integer
    add_column :moves, :castle, :boolean
  end
end
