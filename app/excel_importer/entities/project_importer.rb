#== Schema Information
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
#  donor_id                    :integer
#  EXCEL_HEADERS = ["PID", "Project Name", "Organization", "Main donor", "Scale", "Locations", "Hazard Type", "Intervention Type", "Nature-Based Solutions", "Estimated Cost (in millions)", "Estimated Monetary Benefits (in millions)", "Benefit details", "Original Currency", "Primary Benefits of Intervention", "Co-Benefits of Intervention", "Summary", "Start Year", "Completion Year (if applicable)", "Implementation Status URL", "URL (for further information)"]
# Relations:
# organizations
# donor
# primary_benefits_of_interventions
# co_benefits_of_interventions
# nature_based_solutions
# hazard_types
# locations
# constants:
# IMPLEMENTATION_STATUSES
# INTERVENTION_TYPES
# SCALES

class ProjectImporter

  def initialize(project_id, data)
    @project_id = project_id
    @data = data
    @errors = []
    @project
  end

  attr_reader :errors, :data, :project, :project_id

  def import!
    project = Project.find_or_initialize_by(project_uid: project_id)
    project.name = data['Project Name']&.strip
    project.estimated_cost = data['Estimated Cost (in millions)']
    project.estimated_monetary_benefits = data['Estimated Monetary Benefits (in millions)']
    project.benefit_details = data['Monetary Benefit details']
    project.original_currency = data['Original Currency']
    project.summary = data['Summary']
    project.start_year = data['Start Year']
    project.completion_year = data['Completion Year']
    project.learn_more = data['URL']
    project.references = data['Additional URLs']
    project.scale = self.find_in_constants(data['Scale'], Project::SCALES)
    project.intervention_type = self.find_in_constants(data['Intervention Type'], Project::INTERVENTION_TYPES)
    project.implementation_status = self.find_in_constants(data['Implementation Status'], Project::IMPLEMENTATION_STATUSES)

    organizations = self.find_or_create_some_by_name!(data['Organization'], Organization)
    donors = self.find_or_create_some_by_name!(data['Main donor'], Donor)

    primary_benefits_of_interventions = self.find_some_by_name(data['Primary Benefits of Intervention'], PrimaryBenefitsOfIntervention)
    co_benefits_of_interventions = self.find_some_by_name(data['Co-Benefits of Intervention'], CoBenefitsOfIntervention)
    nature_based_solutions = self.find_some_by_name(data['Nature-Based Solutions'], NatureBasedSolution)
    hazard_types = self.find_some_by_name(data['Hazard Type'], HazardType)

    locations = self.get_locations(data["Locations"])

    if project.valid? && @errors == []
      project.status = 1
      project.save!
      project.organizations = organizations if organizations.present?
      project.donors = donors if donors.present?
      project.primary_benefits_of_interventions = primary_benefits_of_interventions if primary_benefits_of_interventions.present?
      project.co_benefits_of_interventions = co_benefits_of_interventions if co_benefits_of_interventions.present?
      project.nature_based_solutions = nature_based_solutions if nature_based_solutions.present?
      project.hazard_types = hazard_types if hazard_types.present?
      project.locations = locations if locations.present?
      return true
    else
      @errors << { project: project.errors.full_messages } if project.errors.any?
      Rails.logger.info @errors
      return false
    end
  end

  def find_in_constants(string=nil, constant)
    if string.present? && constant.include?(string.downcase)
      string.downcase
    else
      nil
    end
  end

  def find_or_create_some_by_name!(candidates=nil, model)
    if candidates.present?
      ary = candidates.split('|').reject { |i| i.empty? }
      some = []
      ary.each do |name|
        item = model.find_or_create_by!(name: name)
        some << item
      end
      some
    else
      nil
    end
  end

    def find_some_by_name(candidates=nil, model)
    if candidates.present?
      ary = candidates.split('|').reject { |i| i.empty? }
      some = []
      ary.each do |name|
        item = model.where(name: name.downcase).first
        if item.present?
          some << item
        else
          j = {}
          j[model.to_s.underscore.to_sym] = "#{name} is not valid"
          @errors << j
        end
      end
      some
    else
      nil
    end
  end

  def get_locations(candidates)
    if candidates.present?
      ary = candidates.to_s.split('|').reject { |i| i.empty? }
      locations = []
      ary.each do |code|
        adm_levels = code.split('.')
        level = adm_levels.size - 1
        location = Location.where("adm#{level}_code": adm_levels[level])
        location = location.first
        if location.present?
          locations << location
        else
          @errors << {location: "there is no location with code #{code} and admin level #{level}"}
        end
      end
      locations
    else
      nil
    end
  end

end
