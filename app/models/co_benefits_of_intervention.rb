# == Schema Information
#
# Table name: co_benefits_of_interventions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CoBenefitsOfIntervention < ApplicationRecord
  has_and_belongs_to_many :projects
end
