# == Schema Information
#
# Table name: locations_projects
#
#  id          :integer          not null, primary key
#  location_id :integer
#  project_id  :integer
#  latitude    :float
#  longitude   :float
#

class LocationsProject < ApplicationRecord
  belongs_to :location
  belongs_to :project
end
