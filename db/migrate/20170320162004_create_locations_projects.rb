class CreateLocationsProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :locations_projects do |t|
      t.references :location, foreign_key: true
      t.references :project, foreign_key: true
    end
  end
end
