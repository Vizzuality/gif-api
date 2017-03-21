# == Schema Information
#
# Table name: hazard_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class HazardTypeSerializer < ActiveModel::Serializer
  cache key: 'hazard_type'
  attributes :id, :name
end
