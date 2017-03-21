# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  adm0_code  :string
#  adm0_name  :string
#  adm1_code  :string
#  adm1_name  :string
#  adm2_code  :string
#  adm2_name  :string
#  iso        :string
#  level      :integer
#  region     :string
#  centroid   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LocationSerializer < ActiveModel::Serializer
  cache key: 'location'
  attributes :id, :country_iso, :adm0_code, :adm0_name, :adm1_code, :adm1_name, :adm2_code, :adm2_name, :level, :region, :centroid
  def country_iso
    object.iso
  end
  def centroid
    JSON.parse object.centroid if object.centroid
  end
end
