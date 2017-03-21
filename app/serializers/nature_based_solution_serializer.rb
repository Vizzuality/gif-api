# == Schema Information
#
# Table name: nature_based_solutions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NatureBasedSolutionSerializer < ActiveModel::Serializer
  cache key: 'nature_based_solution'
  attributes :id, :name
end
