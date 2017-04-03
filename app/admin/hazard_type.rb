ActiveAdmin.register HazardType do
  menu parent: "Entities", priority: 4
  index do
    selectable_column
    column :id
    column :name
    actions
  end

  filter :name
  filter :projects
  filter :created_at
  filter :updated_at


end