class RemoveBrandFromPins < ActiveRecord::Migration
  def up
  	remove_column :pins, :brand
  end

  def down
  end
end
