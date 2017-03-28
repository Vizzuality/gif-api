# == Schema Information
#
# Table name: donors
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Donor < ApplicationRecord
  has_many :donors_projects, dependent: :nullify
  has_many :projects, through: :donors_projects, dependent: :nullify
end
