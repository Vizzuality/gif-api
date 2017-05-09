module FilterCollection
  def self.fetch_all
    scales = Project::SCALES
    regions = Location.all.pluck(:region).compact.uniq.sort_by{ |m| m.downcase }
    countries = Location.joins(:projects).select(:iso, :adm0_name).order('adm0_name ASC').compact.uniq{ |u| u.iso }
    organizations = Organization.all.select(:id, :name).order('name ASC')
    donors = Donor.all.select(:id, :name).order('name ASC')
    hazard_types = HazardType.all.select(:id, :name).order('name ASC')
    intervention_types = Project::INTERVENTION_TYPES.sort_by{ |m| m.downcase }
    nature_based_solutions = NatureBasedSolution.all.select(:id, :name).order('name ASC')
    primary_benefits = PrimaryBenefitsOfIntervention.all.select(:id, :name).order('name ASC')
    co_benefits = CoBenefitsOfIntervention.all.select(:id, :name).order('name ASC')
    implementation_statuses = Project::IMPLEMENTATION_STATUSES.sort_by{ |m| m.downcase }
    cost_min = Project.where.not(estimated_cost: nil).order('estimated_cost ASC').limit(1).pluck(:estimated_cost).join.to_f
    cost_max = Project.where.not(estimated_cost: nil).order('estimated_cost DESC').limit(1).pluck(:estimated_cost).join.to_f
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
    filters
  end
end
