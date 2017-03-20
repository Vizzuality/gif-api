# == Schema Information
#
# Table name: primary_benefits_of_interventions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :primary_benefits_of_intervention do
    name { Faker::Hacker.say_something_smart }
  end
end
