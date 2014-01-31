class AddPlaceToClicks < ActiveRecord::Migration
  def change
  	add_column :clicks, :place, :text
  end
end
