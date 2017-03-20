# == Schema Information
#
# Table name: hazard_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :hazard_type do
    name { Faker::Hacker.say_something_smart }
  end
end
