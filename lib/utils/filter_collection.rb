module FilterCollection
  def self.fetch_all
    scales = Project::SCALES
    regions = Location.all.pluck(:region).uniq.compact
    hazard_types = HazardType.all.select(:id, :name)
    intervention_types = Project::INTERVENTION_TYPES
    nature_based_solutions = NatureBasedSolution.all.select(:id, :name)
    primary_benefits = PrimaryBenefitsOfIntervention.all.select(:id, :name)
    co_benefits = CoBenefitsOfIntervention.all.select(:id, :name)
    implementation_statuses = Project::IMPLEMENTATION_STATUSES
    cost_min = Project.all.order('estimated_cost ASC').limit(1).pluck(:estimated_cost).join.to_f
    cost_max = Project.all.order('estimated_cost DESC').limit(1).pluck(:estimated_cost).join.to_f
    filters = {}
    filters[:scales] = scales
    filters[:regions] = regions
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
