class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.integer :project_uid
      t.integer :status
      t.text :name
      t.string :scale
      t.float :estimated_cost
      t.float :estimated_monetary_benefits
      t.string :original_currency
      t.text :summary
      t.integer :start_year
      t.integer :completion_year
      t.string :implementation_status
      t.string :intervention_type
      t.text :learn_more
      t.text :references

      t.timestamps
    end
  end
end
