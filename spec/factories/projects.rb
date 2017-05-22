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
#

FactoryGirl.define do
  factory :project do
    sequence :project_uid  do |n|
      n
    end
    name { Faker::Hacker.say_something_smart }
    estimated_cost 3000
    status 1
    scale "national"
    intervention_type "green"
    estimated_monetary_benefits { Faker::Number.decimal(3, 2) }
    original_currency "USD"
    summary { Faker::ChuckNorris.fact }
    start_year 2000
    completion_year 2018
    implementation_status "completed"
    learn_more { Faker::StarWars.quote }
    references { Faker::TwinPeaks.quote }
  end
end
