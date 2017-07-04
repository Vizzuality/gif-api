module FilterCollection
  def self.fetch_all
    scales = Project::SCALES
    regions = Location.all.pluck(:region).compact.uniq.sort_by{ |m| m.downcase }
    countries = Location.joins(:projects).select(:iso, :adm0_name).order('adm0_name ASC').compact.uniq{ |u| u.iso }
    organizations = Organization.all.select(:id, :name).order('name ASC')
    donors = Donor.all.select(:id, :name).order('name ASC')
    hazard_types = HazardType.all.select(:id, :name).order("
            CASE
              WHEN name = 'coastal flooding' THEN '1'
              WHEN name = 'river flooding' THEN '2'
              WHEN name = 'urban flooding' THEN '3'
              WHEN name = 'drought' THEN '4'
              WHEN name = 'landslides' THEN '5'
            END
        ")
    intervention_types = Project::INTERVENTION_TYPES.sort_by{ |m| m.downcase }
    nature_based_solutions = NatureBasedSolution.all.select(:id, :name).order('name ASC')
    currencies = Currency.all.select(:id, :iso, :name).order('name ASC')
    primary_benefits = PrimaryBenefitsOfIntervention.all.select(:id, :name).order('name ASC')
    co_benefits = CoBenefitsOfIntervention.all.select(:id, :name).order('name ASC')
    implementation_statuses = Project::IMPLEMENTATION_STATUSES.sort_by{ |m| m.downcase }
    cost_min = 0.15
    cost_max = 5000.0
    filters = {}
    filters[:scales] = scales
    filters[:regions] = regions
    filters[:organizations] = organizations
    filters[:donors] = donors
    filters[:countries] = countries
    filters[:hazard_types] = hazard_types
    filters[:intervention_types] = intervention_types
    filters[:nature_based_solutions] = nature_based_solutions
    filters[:primary_benefits] = primary_benefits
    filters[:co_benefits] = co_benefits
    filters[:implementation_statuses] = implementation_statuses
    filters[:cost_min] = cost_min
    filters[:cost_max] = cost_max
    filters[:currencies] = currencies
    filters
  end
end
