ActiveAdmin.register Organization do
  menu parent: "Entities", priority: 5
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
