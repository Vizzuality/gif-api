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
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:context) do
    Currency.create(name: 'dolar', iso: 'USD')
    Currency.create(name: 'pound', iso: 'GBP')
  end
  context "Project validation" do
    it "Should be invalid without a name" do
      project = build(:project, name: nil)
      project.valid?
      expect {project.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
    it "Should have a unique name" do
      project = build(:project, name: "name")
      project.save!
      project2 = build(:project, name: "name")
      project2.valid?
      expect {project2.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name has already been taken")
    end
    it "Should have a valid implementation_status" do
      project = build(:project, implementation_status: "TBC")
      project.valid?
      expect {project.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Implementation status is not included in the list")
    end
    it "Should have a valid intervention_type" do
      project = build(:project, intervention_type: "Red")
      project.valid?
      expect {project.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Intervention type is not included in the list")
    end
    it "Should have a valid scale" do
      project = build(:project, scale: "G Major")
      project.valid?
      expect {project.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Scale is not included in the list")
    end
    it "Should have a valid start_year" do
      project = build(:project, start_year: "one thousand")
      project.valid?
      expect {project.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Start year is not a number")
    end
    it "Should have a valid completion_year" do
      project = build(:project, completion_year: "one thousand", start_year: nil)
      project.valid?
      expect {project.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Completion year is not a number")
    end
    it "Should have a completion year after start year" do
      project = build(:project, completion_year: 1990, start_year: 2025)
      project.valid?
      expect {project.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Completion year can't be previous to Start year")
    end
    it "should be valid" do
      project = build(:project)
      project.valid?
      expect(project).to be_valid
    end
  end
  context "scopes" do
    before :each do
      @project = create(:project, name: 'aaaaa real project', scale: 'regional', estimated_cost: 1000, start_year: 2000, completion_year: 2020, implementation_status: 'ongoing', intervention_type: 'hybrid', status: 'published', summary: 'This is The Thing')
      @cbf = create(:co_benefits_of_intervention)
      @pbf = create(:primary_benefits_of_intervention)
      @nbs = create(:nature_based_solution)
      @ht = create(:hazard_type)
      @organization = create(:organization, name: 'aaa')
      @donor = create(:donor, name: 'ddd')
      @not_found_organization = create(:organization, name: 'zzz')
      @location = create(:location, iso: 'SPA')
      @project.co_benefits_of_interventions << @cbf
      @project.primary_benefits_of_interventions << @pbf
      @project.nature_based_solutions << @nbs
      @project.hazard_types << @ht
      @project.organizations << @organization
      @project.donors << @donor
      @project.locations << @location
      @project.reload
      @not_found_project = create(:project, status: 'published', name: 'zzzzz test project', implementation_status: 'completed', summary: 'this not')
      @not_found_project.organizations << @not_found_organization
    end
    it "can be searchable by name" do
      projects = Project.fetch_all(name: 'Real')
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by description" do
      projects = Project.fetch_all(description: 'thing')
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can searches into name and description" do
      projects = Project.fetch_all(q: 'thing')
      projects2 = Project.fetch_all(q: 'real')
      expect(projects).to include(@project)
      expect(projects2).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by scales" do
      projects = Project.fetch_all(scales:[@project.scale])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by implementation status" do
      projects = Project.fetch_all(status:[@project.implementation_status])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by organizations" do
      projects = Project.fetch_all(organizations: [@organization.id])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by donors" do
      projects = Project.fetch_all(donors: [@donor.id])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by countries" do
      projects = Project.fetch_all(countries: [@location.iso])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by regions" do
      projects = Project.fetch_all(regions: [@location.region])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by by_hazard_types" do
      projects = Project.fetch_all(hazard_types: [@ht.id])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by intervention_types" do
      projects = Project.fetch_all(intervention_types: [@project.intervention_type])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by nature based solutions" do
      projects = Project.fetch_all(nature_based_solutions: [@nbs.id])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by primary benefits" do
      projects = Project.fetch_all(primary_benefits: [@pbf.id])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by co-benefits" do
      projects = Project.fetch_all(co_benefits: [@cbf.id])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable between costs" do
      projects = Project.fetch_all(from_cost: 900, to_cost: 1200)
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be ordered by name" do
      projects = Project.fetch_all(order: 'name', direction: 'asc')
      expect(projects.first).to eq(@project)
    end
    it "can be ordered by organizations name" do
      projects = Project.fetch_all(order: 'organization', direction: 'asc')
      expect(projects.first).to eq(@project)
    end
    it "can be ordered by country" do
      projects = Project.fetch_all(order: 'country', direction: 'asc')
      expect(projects.first).to eq(@project)
    end
    it "paginates" do
      projects = Project.fetch_all(offset: 1, limit: 1)
      expect(projects.size).to eq(1)
    end
  end
  context "instance methods" do
    before :each do
      @project = create(:project, name: 'aaaaa real project', scale: 'regional', estimated_cost: 1000, start_year: 2000, completion_year: 2020, implementation_status: 'ongoing', intervention_type: 'hybrid', status: 'published', summary: 'This is The Thing', original_currency: 'GBP')
      @cbf = create(:co_benefits_of_intervention)
      @pbf = create(:primary_benefits_of_intervention)
      @nbs = create(:nature_based_solution)
      @ht = create(:hazard_type)
      @organization = create(:organization, name: 'aaa')
      @donor = create(:donor, name: 'ddd')
      @not_found_organization = create(:organization, name: 'zzz')
      @location = create(:location, iso: 'SPA')
      @project.co_benefits_of_interventions << @cbf
      @project.primary_benefits_of_interventions << @pbf
      @project.nature_based_solutions << @nbs
      @project.hazard_types << @ht
      @project.organizations << @organization
      @project.donors << @donor
      @project.locations << @location
      @project.reload
      @project2 = create(:project, name: 'bbbbb real project', scale: 'regional', estimated_cost: 1000, start_year: 2000, completion_year: 2020, implementation_status: 'ongoing', intervention_type: 'hybrid', status: 'published', summary: 'This is The Thing')
      @project2.hazard_types << @ht
      @project2.locations << @location
      @project2.reload
    end
    it 'finds related projects' do
      expect(@project.related).to include(@project2)
    end
    it 'can be tagged on organizations' do
      @project.organization_list.add('org tag')
      expect(@project.organization_list).to eq(['org tag'])
    end
    it 'can be tagged on donors' do
      @project.organization_list.add('donor tag')
      expect(@project.organization_list).to eq(['donor tag'])
    end
    it 'can be tagged on tags' do
      @project.tag_list.add('tag tag')
      expect(@project.tag_list).to eq(['tag tag'])
    end
    it "can decode and accept location codes and coordinates" do
      location_to_code = create(:location, adm0_code: "142", adm0_name: "Lesotho", adm1_code: "1811", adm1_name: "Quthing", adm2_code: "19026", adm2_name: "Name Unknown", iso: "LSO", level: 2, region: "Sub-Saharan Africa")
      location_by_coordinates = create(:location, adm0_code: "252", adm0_name: "Tuvalu", adm1_code: "3103", adm1_name: "Administrative unit not available", adm2_code: "25820", adm2_name: "Administrative unit not available", iso: "TUV", level: 2, region: "East Asia & Pacific")
      @project.location_codes = '142.1811.19026'
      @project.location_coordinates = [{"lng": -3.71701361553567, "lat": 40.4950695326567}]
      @project.save!
      expect(@project.locations).to include(location_to_code)
      expect(@project.locations).to include(location_by_coordinates)
    end
    it 'converts currencies' do
      expect(@project.costs_usd).to be_a(Float)
    end
  end
end
