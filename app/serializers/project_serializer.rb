# == Schema Information
#
# Table name: projects
#
#  id                                     :integer          not null, primary key
#  project_uid                            :integer
#  status                                 :integer
#  name                                   :text
#  scale                                  :string
#  estimated_cost                         :float
#  estimated_monetary_benefits            :float
#  original_currency                      :string
#  summary                                :text
#  start_year                             :integer
#  completion_year                        :integer
#  implementation_status                  :string
#  intervention_type                      :string
#  learn_more                             :text
#  references                             :text
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  benefit_details                        :text
#  slug                                   :string
#  contributor_name                       :string
#  contributor_organization               :string
#  contact_info                           :text
#  other_nature_based_solution            :string
#  other_primary_benefits_of_intervention :string
#  other_co_benefits_of_intervention      :string
#  user_id                                :integer
#  benefits_currency                      :string
#  costs_usd                              :float
#  benefits_usd                           :float
#  picture_file_name                      :string
#  picture_content_type                   :string
#  picture_file_size                      :integer
#  picture_updated_at                     :datetime
#  other_organization                     :string
#  other_donor                            :string
#

class ProjectSerializer < ActiveModel::Serializer
  cache key: 'project'
  attributes :id, :slug, :name, :contributor_name, :contributor_organization, :scale, :estimated_cost, :estimated_monetary_benefits, :benefit_details, :original_currency, :benefits_currency, :costs_usd, :benefits_usd, :summary, :start_year, :completion_year, :implementation_status, :intervention_type, :learn_more, :references, :other_nature_based_solution, :other_primary_benefits_of_intervention, :other_co_benefits_of_intervention, :image, :other_organization, :other_donor
  has_many :donors, serializer: DonorSerializer
  has_many :co_benefits_of_interventions, serializer: CoBenefitsOfInterventionSerializer
  has_many :primary_benefits_of_interventions, serializer: PrimaryBenefitsOfInterventionSerializer
  has_many :hazard_types, serializer:  HazardTypeSerializer
  has_many :locations, serializer: LocationSerializer
  has_many :nature_based_solutions, serializer: NatureBasedSolutionSerializer
  has_many :organizations, serializer: OrganizationSerializer
  def references
    object.references.split(/[\s|\|]/).delete_if{ |r| !r.include?("http") } if object.references.present?
  end
  def image
    object.picture.url(:default) if object.picture.present?
  end
end
