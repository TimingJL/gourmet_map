class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :phone1
      t.string :phone2
      t.text :note
      t.boolean :vegetarian

      t.timestamps
    end
  end
end
