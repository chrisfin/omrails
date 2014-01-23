class AddActiveToPins < ActiveRecord::Migration
  def change
  	add_column :pins, :active, :boolean
  	add_column :pins, :brand, :text
  	add_column :pins, :item_type, :text
  end
end
