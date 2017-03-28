# == Schema Information
#
# Table name: hazard_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class HazardType < ApplicationRecord
  has_and_belongs_to_many :projects, dependent: :nullify
end
