class LocationsProjectSerializer < ActiveModel::Serializer
  cache key: 'locations_project'
  attributes :latitude, :longitude
end
