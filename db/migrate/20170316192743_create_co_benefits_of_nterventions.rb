class CreateCoBenefitsOfNterventions < ActiveRecord::Migration[5.0]
  def change
    create_table :co_benefits_of_interventions do |t|
      t.string :name

      t.timestamps
    end
  end
end
