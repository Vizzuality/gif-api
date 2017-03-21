# == Schema Information
#
# Table name: primary_benefits_of_interventions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PrimaryBenefitsOfInterventionSerializer < ActiveModel::Serializer
  cache key: 'primary_benefits_of_intervention'
  attributes :id, :name
end
