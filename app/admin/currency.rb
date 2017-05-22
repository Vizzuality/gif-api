ActiveAdmin.register Currency do
  menu parent: "Entities", priority: 15
  permit_params :iso, :name
end
