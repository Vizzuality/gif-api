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
  default_scope { order(name: :asc) }
  validates :name, presence: true, uniqueness: true
  has_many :donors_projects, dependent: :nullify
  has_many :projects, through: :donors_projects, dependent: :nullify

  after_save { projects.find_each(&:touch) }
end
