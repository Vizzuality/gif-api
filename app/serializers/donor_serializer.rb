# == Schema Information
#
# Table name: donors
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DonorSerializer < ActiveModel::Serializer
  cache key: 'donor'
  attributes :id, :name
end
