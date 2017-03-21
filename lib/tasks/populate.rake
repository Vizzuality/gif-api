namespace :db do
  desc 'Creates 100 dummy projects'
  task populate: :environment do
    Organization.create(name: 'World Bank')
    10.times do |n|
      Organization.create(name: Faker::Company.name)
    end
    100.times do |n|
      p = Project.new
      p.project_uid = n
      p.name = Faker::Hacker.say_something_smart
      p.estimated_cost = Faker::Number.decimal(3, 2)
      p.scale = Project::SCALES[rand(4)]
      p.status = 1
      p.intervention_type = Project::INTERVENTION_TYPES[rand(3)]
      p.estimated_monetary_benefits = Faker::Number.decimal(3, 2)
      p.original_currency = "USD"
      p.summary = Faker::ChuckNorris.fact
      p.start_year = 1990 + rand(20)
      p.completion_year = 2010 + rand(20)
      p.implementation_status = Project::IMPLEMENTATION_STATUSES[rand(3)]
      p.learn_more = Faker::StarWars.quote
      p.references = Faker::TwinPeaks.quote
      p.save!
      multi = rand(2)
      # Assign locations
      if multi == 0
        offset = rand(Location.count)
        location = Location.offset(offset).first
        p.locations << location
      else
        countries = Location.where(level: 0)
        offset = rand(countries.count)
        country = countries.offset(offset).first.iso
        locations = Location.where(level: 1, iso: country)
        p.locations << locations
      end
      # Assign co_benefits
      how_many = rand(4) + 1
      offset = rand(CoBenefitsOfIntervention.count)
      items = CoBenefitsOfIntervention.offset(offset).limit(how_many)
      p.co_benefits_of_interventions << items
      # Assign primary_benefits
      how_many = rand(4) + 1
      offset = rand(PrimaryBenefitsOfIntervention.count)
      items = PrimaryBenefitsOfIntervention.offset(offset).limit(how_many)
      p.primary_benefits_of_interventions << items
      # Assign hazard_types
      how_many = rand(4) + 1
      offset = rand(HazardType.count)
      items = HazardType.offset(offset).limit(how_many)
      p.hazard_types << items
      # Assign nature_based_solutions
      how_many = rand(4) + 1
      offset = rand(NatureBasedSolution.count)
      items = NatureBasedSolution.offset(offset).limit(how_many)
      p.nature_based_solutions << items
      # Assign organizations
      how_many = 1
      offset = rand(Organization.count)
      items = Organization.offset(offset).limit(how_many)
      p.organizations << items
    end
  end
end