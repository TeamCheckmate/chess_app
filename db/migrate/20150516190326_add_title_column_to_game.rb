class AddTitleColumnToGame < ActiveRecord::Migration
  def change
  	add_column :games, :title, :string
  end
end
