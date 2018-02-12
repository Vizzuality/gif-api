# == Schema Information
#
# Table name: primary_benefits_of_interventions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PrimaryBenefitsOfIntervention < ApplicationRecord
  has_and_belongs_to_many :projects, dependent: :nullify
  include Downcaseable

  after_save { projects.find_each(&:touch) }
end
