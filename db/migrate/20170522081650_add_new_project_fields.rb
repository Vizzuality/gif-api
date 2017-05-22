class AddNewProjectFields < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :contributor_name, :string
    add_column :projects, :contributor_organization, :string
    add_column :projects, :contact_info, :text
    add_column :projects, :other_nature_based_solution, :string
    add_column :projects, :other_primary_benefits_of_intervention, :string
    add_column :projects, :other_co_benefits_of_intervention, :string
    add_column :projects, :user_id, :integer
    add_index :projects, :user_id
  end
end
