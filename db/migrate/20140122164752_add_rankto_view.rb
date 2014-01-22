class AddRanktoView < ActiveRecord::Migration
  def change
  	add_column :views, :rank, :integer
  end
end
