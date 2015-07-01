class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.references :game, index: true
      t.timestamps
    end
  end
end
