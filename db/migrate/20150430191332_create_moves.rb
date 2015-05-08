class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.references :game, index: true
      t.references :piece, index: true
      t.integer :x_coord
      t.integer :y_coord

      t.timestamps
    end
  end
end
