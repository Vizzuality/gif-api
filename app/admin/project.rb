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

#  IMPLEMENTATION_STATUSES = %w{pipeline ongoing completed}
#  INTERVENTION_TYPES = %w{hybrid green grey}
#  SCALES = %w{local regional national international}
#  enum status: [:under_revision, :published, :unpublished]
#  has_many :organizations_projects,dependent: :nullify
#  has_many :organizations, through: :organizations_projects,dependent: :nullify
#  has_many :donors_projects,dependent: :nullify
#  has_many :donors, through: :donors_projects,dependent: :nullify
#  has_and_belongs_to_many :primary_benefits_of_interventions,dependent: :nullify
#  has_and_belongs_to_many :co_benefits_of_interventions,dependent: :nullify
#  has_and_belongs_to_many :nature_based_solutions,dependent: :nullify
#  has_and_belongs_to_many :hazard_types,dependent: :nullify
#  has_and_belongs_to_many :locations,dependent: :nullify
ActiveAdmin.register Project do

  permit_params :name, :project_uid, :status, :scale, :estimated_cost, :estimated_monetary_benefits, :original_currency, :start_year, :completion_year, :implementation_status, :intervention_type, :summary, :learn_more, :references, :benefit_details, :location_codes, organization_ids:[], donor_ids:[], primary_benefits_of_intervention_ids:[], co_benefits_of_intervention_ids:[], nature_based_solution_ids:[], hazard_type_ids:[]

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name, as: :string
      f.input :project_uid
      f.input :status, as: :select, collection: %w{under_revision published unpublished}
      f.input :location_codes, input_html: { value: object.current_location_codes }
      f.input :scale, as: :select, collection: Project::SCALES
      f.input :donors
      f.input :primary_benefits_of_interventions
      f.input :co_benefits_of_interventions
      f.input :nature_based_solutions
      f.input :hazard_types
      f.input :organizations
      f.input :estimated_cost
      f.input :estimated_monetary_benefits
      f.input :original_currency
      f.input :start_year
      f.input :completion_year
      f.input :implementation_status, collection: Project::IMPLEMENTATION_STATUSES
      f.input :intervention_type, as: :select, collection: Project::INTERVENTION_TYPES
      f.input :summary
      f.input :learn_more
      f.input :references
      f.input :benefit_details
    end
    f.actions
  end

end
