class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
		t.belongs_to :user
      	t.belongs_to :pin
      	t.timestamps
    end
  end
end