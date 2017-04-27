# == Schema Information
#
# Table name: projects
#
#  id                          :integer          not null, primary key
#  project_uid                 :integer
#  status                      :integer
#  name                        :text
#  scale                       :string
#  estimated_cost              :float
#  estimated_monetary_benefits :float
#  original_currency           :string
#  summary                     :text
#  start_year                  :integer
#  completion_year             :integer
#  implementation_status       :string
#  intervention_type           :string
#  learn_more                  :text
#  references                  :text
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  benefit_details             :text
#  slug                        :string
#

class ProjectSerializer < ActiveModel::Serializer
  cache key: 'project'
  attributes :id, :slug, :name, :scale, :estimated_cost, :estimated_monetary_benefits, :benefit_details, :original_currency, :summary, :start_year, :completion_year, :implementation_status, :intervention_type, :learn_more, :references
  has_many :donors, serializer: DonorSerializer
  has_many :co_benefits_of_interventions, serializer: CoBenefitsOfInterventionSerializer
  has_many :primary_benefits_of_interventions, serializer: PrimaryBenefitsOfInterventionSerializer
  has_many :hazard_types, serializer:  HazardTypeSerializer
  has_many :locations, serializer: LocationSerializer
  has_many :nature_based_solutions, serializer: NatureBasedSolutionSerializer
  has_many :organizations, serializer: OrganizationSerializer
end
