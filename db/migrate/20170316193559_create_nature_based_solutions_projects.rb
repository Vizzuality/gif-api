class CreateNatureBasedSolutionsProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :nature_based_solutions_projects, id: false do |t|
      t.integer :project_id, foreign_key: true
      t.integer :nature_based_solution_id, foreign_key: true
    end
    add_index(:nature_based_solutions_projects, [:project_id, :nature_based_solution_id], unique: true, name: 'nbsp')
  end
end
