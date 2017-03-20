# == Schema Information
#
# Table name: nature_based_solutions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :nature_based_solution do
    name { Faker::Hacker.say_something_smart }
  end
end
