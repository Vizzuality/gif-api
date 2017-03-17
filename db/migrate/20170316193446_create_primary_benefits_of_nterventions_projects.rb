class CreatePrimaryBenefitsOfNterventionsProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :primary_benefits_of_interventions_projects, id: false do |t|
      t.integer :project_id, foreign_key: true
      t.integer :primary_benefits_of_intervention_id, foreign_key: true
    end
    add_index(:primary_benefits_of_interventions_projects, [:project_id, :primary_benefits_of_intervention_id], unique: true, name: 'pbfp')
  end
end
