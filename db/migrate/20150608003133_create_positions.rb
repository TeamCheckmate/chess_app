class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :x_coord
      t.integer :y_coord
      t.references :piece, index: true
      t.references :game, index: true
      t.timestamps
    end
  end
end
