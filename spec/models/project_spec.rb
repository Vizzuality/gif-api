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
    it "should be valid" do
      project = build(:project)
      project.valid?
      expect(project).to be_valid
    end
  end
end
