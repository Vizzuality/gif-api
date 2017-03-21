# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrganizationSerializer < ActiveModel::Serializer
  cache key: 'organization'
  attributes :id, :name
end
