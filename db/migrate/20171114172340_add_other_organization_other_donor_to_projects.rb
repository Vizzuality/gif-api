class AddOtherOrganizationOtherDonorToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :other_organization, :string
    add_column :projects, :other_donor, :string
  end
end
