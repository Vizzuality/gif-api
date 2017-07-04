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

    locations_projects = self.set_locations!(data["Locations"])

    if project.valid? && @errors == []
      project.status = 1
      project.save!
      project.organizations = organizations if organizations.present?
      project.donors = donors if donors.present?
      project.primary_benefits_of_interventions = primary_benefits_of_interventions if primary_benefits_of_interventions.present?
      project.co_benefits_of_interventions = co_benefits_of_interventions if co_benefits_of_interventions.present?
      project.nature_based_solutions = nature_based_solutions if nature_based_solutions.present?
      project.hazard_types = hazard_types if hazard_types.present?
      project.locations_projects = locations_projects if locations_projects.present?
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

  def set_locations!(raw_string)
    new_locations_projects = []
    if raw_string.present?
      candidates = self.parse_coordinates_from_excel(raw_string)
      if candidates.any?
        candidates.each do |candidate|
          begin
            lat = candidate[:lat]
            long = candidate[:ltd]
          rescue
            nil
          end
          location = self.get_location_by_coordinates(lat, long) if lat.present? && long.present?
          if location.present?
            if location.centroid.present?
              coordinates = JSON.parse(location.centroid)["coordinates"]
            else
              coordinates = [nil, nil]
            end
            new_locations_project = LocationsProject.new(location: location, latitude: lat, longitude: long)
            new_locations_projects << new_locations_project
          else
            @errors << {location: "there is no location with latitude #{lat} and longitude #{long}"}
          end
        end
      end
    end
    if new_locations_projects.any? && @errors.blank?
      new_locations_projects
    else
      nil
    end
  end

  def parse_coordinates_from_excel(coordinates)
    parsed_coordinates = nil
      begin
        parsed_coordinates = coordinates.split("|").map{ |p| {"lat": p.split(",")[0], "ltd": p.split(",")[1] } }
      rescue
        @errors << {location: "wrong format"}
      end
    parsed_coordinates
  end

  def get_location_by_coordinates(lat, long)
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

end
