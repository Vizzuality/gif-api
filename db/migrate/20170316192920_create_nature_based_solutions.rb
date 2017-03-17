class CreateNatureBasedSolutions < ActiveRecord::Migration[5.0]
  def change
    create_table :nature_based_solutions do |t|
      t.string :name

      t.timestamps
    end
  end
end
