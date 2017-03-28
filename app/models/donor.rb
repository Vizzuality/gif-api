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
  has_many :donors_projects
  has_many :projects, through: :donors_projects
end
