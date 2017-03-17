# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Organization, type: :model do
  context "Organization validation" do
    it "Should be invalid without a name" do
      organization = build(:organization, name: nil)
      organization.valid?
      expect {organization.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
    it "Should have a unique name" do
      organization = build(:organization, name: "name")
      organization.save!
      organization2 = build(:organization, name: "name")
      organization2.valid?
      expect {organization2.save!}.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name has already been taken")
    end
    it "should be valid" do
      organization = build(:organization)
      organization.valid?
      expect(organization).to be_valid
    end
  end
end
