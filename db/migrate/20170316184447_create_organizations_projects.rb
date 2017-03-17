class CreateOrganizationsProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations_projects do |t|
      t.references :organization, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
