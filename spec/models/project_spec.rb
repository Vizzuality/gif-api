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

require 'rails_helper'

RSpec.describe Project, type: :model do
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
      @project = create(:project, name: 'aaaaa test project', scale: 'regional', estimated_cost: 1000, start_year: 2000, completion_year: 2020, implementation_status: 'pipeline', intervention_type: 'grey', status: 'published')
      @cbf = create(:co_benefits_of_intervention)
      @pbf = create(:primary_benefits_of_intervention)
      @nbs = create(:nature_based_solution)
      @ht = create(:hazard_type)
      @organization = create(:organization, name: 'aaa')
      @not_found_organization = create(:organization, name: 'zzz')
      @location = create(:location, iso: 'SPA')
      @project.co_benefits_of_interventions << @cbf
      @project.primary_benefits_of_interventions << @pbf
      @project.nature_based_solutions << @nbs
      @project.hazard_types << @ht
      @project.organizations << @organization
      @project.locations << @location
      @not_found_project = create(:project, status: 'published', name: 'zzzzz test project')
      @not_found_project.organizations << @not_found_organization
    end
    it "can be searchable by name" do
      projects = Project.fetch_all(name:[@project.name])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by scales" do
      projects = Project.fetch_all(scales:[@project.scale])
      expect(projects).to include(@project)
      expect(projects).not_to include(@not_found_project)
    end
    it "can be searchable by organizations" do
      projects = Project.fetch_all(organizations: [@organization.id])
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
    it "can be ordered by countru" do
      projects = Project.fetch_all(order: 'country', direction: 'asc')
      expect(projects.first).to eq(@project)
    end
  end
end