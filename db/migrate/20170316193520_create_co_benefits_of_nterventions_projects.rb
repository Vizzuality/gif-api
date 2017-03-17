class CreateCoBenefitsOfNterventionsProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :co_benefits_of_interventions_projects, id: false do |t|
      t.integer :project_id, foreign_key: true
      t.integer :co_benefits_of_intervention_id, foreign_key: true
    end
    add_index(:co_benefits_of_interventions_projects, [:project_id, :co_benefits_of_intervention_id], unique: true, name: 'cbfp')
  end
end