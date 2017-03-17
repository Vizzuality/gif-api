class CreatePrimaryBenefitsOfNterventions < ActiveRecord::Migration[5.0]
  def change
    create_table :primary_benefits_of_interventions do |t|
      t.string :name

      t.timestamps
    end
  end
end
