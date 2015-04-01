class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.string   :piece_type
      t.integer  :x_coord
      t.integer  :y_coord
      t.string   :color
      t.integer  :user_id
      t.integer  :game_id
      t.timestamps
    end

    add_index :pieces, :game_id
  end
end
