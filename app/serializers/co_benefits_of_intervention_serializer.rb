# == Schema Information
#
# Table name: co_benefits_of_interventions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CoBenefitsOfInterventionSerializer < ActiveModel::Serializer
  cache key: 'co_benefits_of_intervention'
  attributes :id, :name
end
