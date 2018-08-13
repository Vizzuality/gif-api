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

class Project < ApplicationRecord
  require 'csv'
  extend FriendlyId
  include ActiveModel::Dirty
  friendly_id :name, use: :slugged
  acts_as_taggable
  acts_as_taggable_on :organizations, :donors, :tags
  def slug_candidates
    [
      :name,
      [:name, :project_uid]
    ]
  end
  has_attached_file :picture, styles: { thumb: "100x100>" }, default_url: "/uploads/images/:style/missing.png",
    path: "#{Rails.root}/public/system/pictures/:id/:style/:basename.:extension",
    url: "/system/pictures/:id/:style/:basename.:extension"
  attr_accessor :location_coordinates
  attr_accessor :image_base
  attr_accessor :picture_name
  IMPLEMENTATION_STATUSES = ["ongoing", "completed", "planning stage"]
  INTERVENTION_TYPES = %w{hybrid green}
  SCALES = %w{local regional national international}
  enum status: [:under_revision, :published, :unpublished]
  has_many :organizations_projects,dependent: :nullify
  has_many :organizations, through: :organizations_projects, dependent: :nullify, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_many :donors_projects,dependent: :nullify
  has_many :donors, through: :donors_projects,dependent: :nullify, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :primary_benefits_of_interventions,dependent: :nullify, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :co_benefits_of_interventions,dependent: :nullify, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :nature_based_solutions,dependent: :nullify, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :hazard_types,dependent: :nullify, after_add: :touch_updated_at, after_remove: :touch_updated_at
  belongs_to :user, optional: true
  has_many :locations_projects, dependent: :nullify
  has_many :locations, through: :locations_projects, dependent: :nullify, after_add: :touch_updated_at, after_remove: :touch_updated_at
  validates :name, presence: true, uniqueness: true
  validates_inclusion_of :implementation_status, in: IMPLEMENTATION_STATUSES, allow_nil: true
  validates_inclusion_of :scale, in: SCALES, allow_nil: true
  validates_inclusion_of :intervention_type, in: INTERVENTION_TYPES, allow_nil: true
  validates :start_year, numericality: true, allow_nil: true
  validates :completion_year, numericality: true, allow_nil: true
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  validate :years_timeline_validation
  validate :costs_currency_validaton
  validate :benefits_currency_validaton

  before_validation :set_locations!, if: Proc.new { |project| project.location_coordinates.present? }
  before_validation { self.picture.clear if self.remove_picture == '1' }
  before_save :convert_currencies
  before_validation :parse_image

  scope :publihsed,                 ->                        { where(status: :published) }
  scope :by_name,                   -> name                   { where('projects.name ilike ?', "%%#{name}%%") }
  scope :by_description,            -> description            { where('projects.summary ilike ?', "%%#{description}%%") }
  scope :by_text,                   -> text                   { by_name(text).or(by_description(text)) }
  scope :by_scales,                 -> scales                 { where(scale: scales) }
  scope :by_organizations,          -> organizations          { where(organizations: { id: organizations } ) }
  scope :by_donors,                 -> donors                 { where(donors: { id: donors } ) }
  scope :by_hazard_types,           -> hazard_types           { where(hazard_types: { id: hazard_types } ) }
  scope :by_co_benefits,            -> co_benefits            { where(co_benefits_of_interventions: { id: co_benefits } ) }
  scope :by_status,                 -> status                 { where(implementation_status: status) }
  scope :by_primary_benefits,       -> primary_benefits       { where(primary_benefits_of_interventions: { id: primary_benefits } ) }
  scope :by_countries,              -> countries              { where(locations: { iso: countries } ) }
  scope :country_eq,                -> country                { joins(:locations).where(locations: { adm0_name: country }).distinct }
  scope :by_regions,                -> regions                { where(locations: { region: regions } ) }
  scope :by_intervention_types,     -> intervention_types     { where(intervention_type:  intervention_types) }
  scope :by_nature_based_solutions, -> nature_based_solutions { where( nature_based_solutions: { id: nature_based_solutions } ) }
  scope :from_cost,                 -> starting_cost          { where('projects.costs_usd >= ?', starting_cost) }
  scope :to_cost,                   -> ending_cost            { where('projects.costs_usd <= ?', ending_cost) }
  scope :organization_tags_eq,      -> tags                   { tagged_with(tags, on: :organizations, any: true) }
  scope :donor_tags_eq,             -> tags                   { tagged_with(tags, on: :donors, any: true) }
  scope :tag_list,                  -> tags                   { tagged_with(tags, on: :tags, any: true) }

  def self.fetch_all(options={})
    projects = Project.eager_load([:locations, :co_benefits_of_interventions, :primary_benefits_of_interventions, :organizations, :donors, :nature_based_solutions, :hazard_types, :nature_based_solutions]).published
    projects = projects.by_name(options[:name])                                      if options[:name]
    projects = projects.by_description(options[:description])                        if options[:description]
    projects = projects.by_text(options[:q])                                         if options[:q]
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

  def self.ransackable_scopes(auth=nil)
    %i(organization_tags_eq donor_tags_eq tag_list country_eq)
  end

  def self.find_by_lug_or_id(param)
    if param.to_i.to_s == param.to_s
      find(param)
    else
      friendly.find(param)
    end
  end

  def self.get_order(options={})
    direction = options[:direction] && %w{asc desc}.include?(options[:direction]) ? options[:direction] : 'asc'
    if options[:order]
      order = 'projects.name'                       if options[:order] == 'name'
      order = 'organizations.name'                  if options[:order] == 'organization'
      order = 'donors.name'                  if options[:order] == 'donor'
      order = 'locations.adm0_name'                 if options[:order] == 'country'
      order = 'hazard_types.name'                   if options[:order] == 'hazard_type'
      order = 'nature_based_solutions.name'         if options[:order] == 'nature_based_solution'
      order = 'projects.start_year'                 if options[:order] == 'start_year'
      order = 'projects.completion_year'            if options[:order] == 'completion_year'
    end
    order ||= 'projects.created_at'
    "#{order} #{direction}"
  end

  def self.to_csv
    columns = ExcelImporter::EXCEL_HEADERS
    #EXCEL_HEADERS = ["PID", "Project Name", "Organization", "Main donor", "Scale", "Country", "Province", "District", "Locations", "Hazard Type", "Intervention Type", "Nature-Based Solutions", "Estimated Cost (in millions)", "Estimated Monetary Benefits (in millions)", "Monetary Benefit details", "Original Currency", "Primary Benefits of Intervention", "Co-Benefits of Intervention", "Summary", "Start Year", "Completion Year", "Implementation Status", "URL", "Additional URLs"]

    CSV.generate(headers: true) do |csv|
      csv << columns
      all.each do |project|
        attributes = {}
        attributes['PID'] = project.project_uid
        attributes['Project Name'] = project.name
        attributes['Estimated Cost (in millions)'] = project.estimated_cost
        attributes['Estimated Monetary Benefits (in millions)'] = project.estimated_monetary_benefits
        attributes['Monetary Benefit details'] = project.benefit_details
        attributes['Original Currency'] = project.original_currency
        attributes['Summary'] = project.summary
        attributes['Start Year'] = project.start_year
        attributes['Completion Year'] = project.completion_year
        attributes['URL'] = project.learn_more
        attributes['Additional URLs'] = project.references
        attributes['Scale'] = project.scale
        attributes['Intervention Type'] = project.intervention_type
        attributes['Implementation Status'] = project.implementation_status

        attributes['Organization'] = project.organizations.pluck(:name).reject(&:blank?).join("|")
        attributes['Main donor'] = project.donors.pluck(:name).reject(&:blank?).join("|")
        attributes['Primary Benefits of Intervention'] = project.primary_benefits_of_interventions.pluck(:name).reject(&:blank?).join("|")
        attributes['Co-Benefits of Intervention'] = project.co_benefits_of_interventions.pluck(:name).reject(&:blank?).join("|")
        attributes['Nature-Based Solutions'] = project.nature_based_solutions.pluck(:name).reject(&:blank?).join("|")
        attributes['Hazard Type'] = project.hazard_types.pluck(:name).reject(&:blank?).join("|")
        attributes["Locations"] = project.locations.pluck(:id).reject(&:blank?).join("|")
        attributes["Country"] = project.locations.pluck(:adm0_name).reject(&:blank?).join("|")
        attributes["Province"] = project.locations.pluck(:adm1_name).reject(&:blank?).join("|")
        attributes["District"] = project.locations.pluck(:adm2_name).reject(&:blank?).join("|")
        csv << attributes.values_at(*columns)
      end
    end
  end

  def related
    hazard_types = self.hazard_types.pluck(:id)
    countries = self.locations.pluck(:iso)
    related = Project.joins([:hazard_types, :locations]).by_hazard_types(hazard_types).by_countries(countries).where.not(id: self.id).distinct.limit(3)
    related
  end

  attr_writer :remove_picture

  def remove_picture
    @remove_picture || false
  end

  def convert_currencies
    year = self.start_year.present? ? self.start_year : Time.now.year
    c_currency = self.original_currency.present? ? self.original_currency : "USD"
    b_currency = self.original_currency.present? ? self.original_currency : "USD"
    if self.estimated_cost.present? && (self.estimated_cost_changed? || self.original_currency_changed? || self.new_record?)
      if c_currency == "USD"
        amount_c = self.estimated_cost
      else
        amount_c = CurrencyConverter.convert(self.estimated_cost, c_currency, year)
      end
      self.costs_usd = amount_c
    end
    if self.estimated_monetary_benefits.present? && (self.estimated_monetary_benefits_changed? || self.original_currency_changed? || self.new_record?)
      if b_currency == "USD"
        amount_b = self.estimated_monetary_benefits
      else
        amount_b = CurrencyConverter.convert(self.estimated_monetary_benefits, b_currency, year)
      end
      self.benefits_usd = amount_b
    end
  end

  def set_locations!
    new_locations_projects = []
    if self.location_coordinates.present?
      candidates = Project.parse_if_string(self.location_coordinates)
      if candidates.any?
        candidates.each do |candidate|
          begin
            lat = candidate[:lat]
            long = candidate[:ltd]
          rescue
            nil
          end
          location = Project.get_location_by_coordinates(lat, long) if lat.present? && long.present?
          if location.present?
            if location.centroid.present?
              coordinates = JSON.parse(location.centroid)["coordinates"]
            else
              coordinates = [nil, nil]
            end
            new_locations_project = LocationsProject.new(location: location, latitude: lat, longitude: long)
            new_locations_projects << new_locations_project
          else
            errors.add(:project_location_codes, "there is no location with latitude #{lat} and longitude #{long}")
          end
        end
      end
    end
    if new_locations_projects.any? && self.errors.messages.blank?
      self.locations_projects = new_locations_projects
    else
      nil
    end
  end

  def self.parse_if_string(coordinates)
    parsed_coordinates = nil
    if coordinates.is_a? Array
      parsed_coordinates = coordinates
    else
      begin
        parsed_coordinates = JSON.parse(coordinates, {symbolize_names: true})
      rescue
        errors.add(:project_location_codes, "wrong coordinates")
      end
    end
    parsed_coordinates
  end

  def self.get_location_by_coordinates(lat, long)
    require 'cartowrap'
    api = Cartowrap::API.new(nil, "simbiotica")
    query = "SELECT * from gaul_final where st_intersects(the_geom, ST_SetSRID(ST_MakePoint(#{long}, #{lat}),4326)) order by level desc limit 1"
    api.send_query(query)
    begin
      response = JSON.parse(api.response)["rows"][0]
      level = response["level"]
      code = response["adm#{level}_code"]
      location = Location.where("level=#{level} AND adm#{level}_code='#{code}'").first
      location
    rescue
      nil
    end
  end

  private
    def years_timeline_validation
      if start_year.present? && completion_year.present? && completion_year < start_year
        errors.add(:completion_year, "can't be previous to Start year")
      end
    end
    def costs_currency_validaton
      if self.original_currency.present?
        currency = Currency.find_by(iso: self.original_currency)
        errors.add(:original_currency, "not a valid currency") unless currency.present?
      end
    end

    def benefits_currency_validaton
      if self.benefits_currency.present?
        currency = Currency.find_by(iso: self.benefits_currency)
        errors.add(:benefits_currency, "not a valid currency") unless currency.present?
      end
    end

    def touch_updated_at(relation)
      self.touch if persisted?
    end

    def parse_image
      image = Paperclip.io_adapters.for(image_base)
      image.original_filename = self.picture_name
      self.picture = image
    end

end
