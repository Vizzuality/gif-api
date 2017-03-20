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
#

class Project < ApplicationRecord
  IMPLEMENTATION_STATUSES = %w{pipeline ongoing completed}
  INTERVENTION_TYPES = %w{hybrid green grey}
  SCALES = %w{local regional national international}
  enum status: [:under_revision, :published, :unpublished]
  has_many :organizations_projects
  has_many :organizations, through: :organizations_projects
  has_and_belongs_to_many :primary_benefits_of_interventions
  has_and_belongs_to_many :co_benefits_of_interventions
  has_and_belongs_to_many :nature_based_solutions
  has_and_belongs_to_many :hazard_types
  has_and_belongs_to_many :locations
  validates :name, presence: true, uniqueness: true
  validates_inclusion_of :implementation_status, in: IMPLEMENTATION_STATUSES, allow_nil: true
  validates_inclusion_of :scale, in: SCALES, allow_nil: true
  validates_inclusion_of :intervention_type, in: INTERVENTION_TYPES, allow_nil: true
  validates :start_year, numericality: true, allow_nil: true
  validates :completion_year, numericality: true, allow_nil: true
  validate :years_timeline
  scope :publihsed,                 ->                        { where(status: :published) }
  scope :by_name,                   -> name                   { where('projects.name = ?', name) }
  scope :by_scales,                 -> scales                 { where(scale: scales) }
  scope :by_organizations,          -> organizations          { where(organizations: { id: organizations } ) }
  scope :by_hazard_types,           -> hazard_types           { where(hazard_types: { id: hazard_types } ) }
  scope :by_countries,              -> countries              { where(locations: { adm0_code: countries } ) }
  scope :by_regions,                 -> regions               { where(locations: { region: regions } ) }
  scope :by_intervention_types,     -> intervention_types     { where(intervention_type:  intervention_types) }
  scope :by_nature_based_solutions, -> nature_based_solutions { where( nature_based_solutions: { id: nature_based_solutions } ) }
  scope :from_cost,                 -> starting_cost          { where('projects.estimated_cost >= ?', starting_cost) }
  scope :to_cost,                   -> ending_cost            { where('projects.estimated_cost <= ?', ending_cost) }

  def self.fetch_all(options={})
    projects = Project.eager_load([:locations, :co_benefits_of_interventions, :primary_benefits_of_interventions, :organizations, :nature_based_solutions, :hazard_types, :nature_based_solutions]).published
    projects = projects.by_name(options[:name])                                      if options[:name]
    projects = projects.by_scales(options[:scales])                                  if options[:scales]
    projects = projects.by_organizations(options[:organizations])                    if options[:organizations]
    projects = projects.by_countries(options[:countries])                            if options[:countries]
    projects = projects.by_regions(options[:regions])                                if options[:regions]
    projects = projects.by_hazard_types(options[:hazard_types])                      if options[:hazard_types]
    projects = projects.by_intervention_types(options[:intervention_types])          if options[:intervention_types]
    projects = projects.by_nature_based_solutions(options[:nature_based_solutions])  if options[:nature_based_solutions]
    projects = projects.from_cost(options[:from_cost])                               if options[:from_cost]
    projects = projects.to_cost(options[:to_cost])                                   if options[:to_cost]
    projects = projects.order(self.get_order(options))
    projects.distinct
  end

  def self.get_order(options={})
    direction = options[:direction] && %w{asc desc}.include?(options[:direction]) ? options[:direction] : 'asc'
    if options[:order]
      order = 'projects.name'                       if options[:order] == 'name'
      order = 'organizations.name'                  if options[:order] == 'organization'
      order = 'locations.adm0_name'                 if options[:order] == 'country'
      order = 'hazard_types.name'                   if options[:order] == 'hazard_type'
      order = 'nature_based_solutions.name'         if options[:order] == 'nature_based_solution'
      order = 'projects.start_year'                 if options[:order] == 'start_year'
      order = 'projects.completion_year'            if options[:order] == 'completion_year'
    end
    order ||= 'projects.created_at'
    "#{order} #{direction}"
  end

  private
    def years_timeline
      if start_year.present? && completion_year.present? && completion_year < start_year
        errors.add(:completion_year, "can't be previous to Start year")
      end
    end

end
