class CreateHazardTypesProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :hazard_types_projects do |t|
      t.references :project, foreign_key: true
      t.references :hazard_type, foreign_key: true
    end
  end
end
