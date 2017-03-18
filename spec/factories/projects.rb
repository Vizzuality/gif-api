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

FactoryGirl.define do
  factory :project do
    sequence :project_uid  do |n|
      n
    end
    name { Faker::Hacker.say_something_smart }
    estimated_cost { Faker::Number.decimal(3, 2) }
    status 1
    scale "National"
    intervention_type "Green"
    estimated_monetary_benefits { Faker::Number.decimal(3, 2) }
    original_currency "USD"
    summary { Faker::ChuckNorris.fact }
    start_year 2000
    completion_year 2018
    implementation_status "Completed"
    learn_more { Faker::StarWars.quote }
    references { Faker::TwinPeaks.quote }
  end
end
