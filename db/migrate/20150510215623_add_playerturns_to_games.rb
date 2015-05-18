class AddPlayerturnsToGames < ActiveRecord::Migration
  def change
    add_column :games, :playerturn, :string, default: "white"
  end
end
