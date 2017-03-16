# == Schema Information
#
# Table name: projects
#
#  id                               :integer          not null, primary key
#  project_uid                      :integer
#  name                             :text
#  estimated_cost                   :float
#  estimated_monetary_benefits      :float
#  original_currency                :string
#  primary_benefits_of_intervention :float
#  cobenefits_of_intervention       :float
#  summary                          :text
#  start_year                       :integer
#  completion_year                  :integer
#  implementation_status            :string
#  learn_more                       :text
#  references                       :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#

class Project < ApplicationRecord
end
