class AddLatitudeLongitudeToLoctionsProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :locations_projects, :latitude, :float
    add_column :locations_projects, :longitude, :float
  end
end
