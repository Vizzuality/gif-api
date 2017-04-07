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
#

class Project < ApplicationRecord
  IMPLEMENTATION_STATUSES = %w{ongoing completed}
  INTERVENTION_TYPES = %w{hybrid green}
  SCALES = %w{local regional national international}
  enum status: [:under_revision, :published, :unpublished]
  has_many :organizations_projects,dependent: :nullify
  attr_accessor :location_codes
  has_many :organizations, through: :organizations_projects,dependent: :nullify
  has_many :donors_projects,dependent: :nullify
  has_many :donors, through: :donors_projects,dependent: :nullify
  has_and_belongs_to_many :primary_benefits_of_interventions,dependent: :nullify
  has_and_belongs_to_many :co_benefits_of_interventions,dependent: :nullify
  has_and_belongs_to_many :nature_based_solutions,dependent: :nullify
  has_and_belongs_to_many :hazard_types,dependent: :nullify
  has_and_belongs_to_many :locations,dependent: :nullify
  validates :name, presence: true, uniqueness: true
  validates_inclusion_of :implementation_status, in: IMPLEMENTATION_STATUSES, allow_nil: true
  validates_inclusion_of :scale, in: SCALES, allow_nil: true
  validates_inclusion_of :intervention_type, in: INTERVENTION_TYPES, allow_nil: true
  validates :start_year, numericality: true, allow_nil: true
  validates :completion_year, numericality: true, allow_nil: true
  validate :years_timeline

  before_validation :set_locations!, if: Proc.new { |project| project.location_codes.present? }

  scope :publihsed,                 ->                        { where(status: :published) }
  scope :by_name,                   -> name                   { where('projects.name ilike ?', "%%#{name}%%") }
  scope :by_scales,                 -> scales                 { where(scale: scales) }
  scope :by_organizations,          -> organizations          { where(organizations: { id: organizations } ) }
  scope :by_donors,                 -> donors                 { where(donors: { id: donors } ) }
  scope :by_hazard_types,           -> hazard_types           { where(hazard_types: { id: hazard_types } ) }
  scope :by_co_benefits,            -> co_benefits            { where(co_benefits_of_interventions: { id: co_benefits } ) }
  scope :by_status,                 -> status                 { where(implementation_status: status) }
  scope :by_primary_benefits,       -> primary_benefits       { where(primary_benefits_of_interventions: { id: primary_benefits } ) }
  scope :by_countries,              -> countries              { where(locations: { iso: countries } ) }
  scope :by_regions,                -> regions                { where(locations: { region: regions } ) }
  scope :by_intervention_types,     -> intervention_types     { where(intervention_type:  intervention_types) }
  scope :by_nature_based_solutions, -> nature_based_solutions { where( nature_based_solutions: { id: nature_based_solutions } ) }
  scope :from_cost,                 -> starting_cost          { where('projects.estimated_cost >= ?', starting_cost) }
  scope :to_cost,                   -> ending_cost            { where('projects.estimated_cost <= ?', ending_cost) }

  def self.fetch_all(options={})
    projects = Project.eager_load([:locations, :co_benefits_of_interventions, :primary_benefits_of_interventions, :organizations, :donors, :nature_based_solutions, :hazard_types, :nature_based_solutions]).published
    projects = projects.by_name(options[:name])                                      if options[:name]
    projects = projects.by_scales(options[:scales])                                  if options[:scales]
    projects = projects.by_organizations(options[:organizations])                    if options[:organizations]
    projects = projects.by_donors(options[:donors])                                  if options[:donors]
    projects = projects.by_countries(options[:countries])                            if options[:countries]
    projects = projects.by_regions(options[:regions])                                if options[:regions]
    projects = projects.by_hazard_types(options[:hazard_types])                      if options[:hazard_types]
    projects = projects.by_intervention_types(options[:intervention_types])          if options[:intervention_types]
    projects = projects.by_nature_based_solutions(options[:nature_based_solutions])  if options[:nature_based_solutions]
    projects = projects.by_co_benefits(options[:co_benefits])                        if options[:co_benefits]
    projects = projects.by_primary_benefits(options[:primary_benefits])              if options[:primary_benefits]
    projects = projects.by_status(options[:status])                                  if options[:status]
    projects = projects.from_cost(options[:from_cost])                               if options[:from_cost]
    projects = projects.to_cost(options[:to_cost])                                   if options[:to_cost]
    projects = projects.offset(options[:offset])                                     if options[:offset]
    projects = projects.limit(options[:limit])                                       if options[:limit]
    projects = projects.order(self.get_order(options))
    projects.distinct
  end

  def current_location_codes
    location_codes = []
    self.locations.each do |l|
      if l.adm0_code.present?
       location_code = l.adm0_code
      else
        return ''
      end
      location_code += ".#{l.adm1_code}" if l.adm1_code.present?
      location_code += ".#{l.adm2_code}" if l.adm2_code.present?
      location_codes << location_code
    end
    location_codes.join('|')
  end

  def set_locations!
    candidates = self.location_codes
    if candidates.present?
      ary = candidates.to_s.split('|').reject { |i| i.empty? }
      new_locations = []
      ary.each do |code|
        adm_levels = code.split('.')
        level = adm_levels.size - 1
        location = Location.where("adm#{level}_code": adm_levels[level])
        location = location.first
        if location.present?
          new_locations << location
        else
          errors.add(:project_location_codes, "there is no location with code #{code} and admin level #{level}")
        end
      end
      self.locations = new_locations
    else
      nil
    end
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
