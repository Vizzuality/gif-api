class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :adm0_code
      t.string :adm0_name
      t.string :adm1_code
      t.string :adm1_name
      t.string :adm2_code
      t.string :adm2_name
      t.string :iso
      t.integer :level
      t.string :region
      t.text :centroid

      t.timestamps
    end
  end
end
