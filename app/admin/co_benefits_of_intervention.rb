ActiveAdmin.register CoBenefitsOfIntervention do
  menu parent: "Entities", priority: 2

  permit_params :name

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
