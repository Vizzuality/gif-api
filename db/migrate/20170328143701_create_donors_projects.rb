class CreateDonorsProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :donors_projects do |t|
      t.references :donor, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
