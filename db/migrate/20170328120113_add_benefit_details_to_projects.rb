class AddBenefitDetailsToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :benefit_details, :text
  end
end
