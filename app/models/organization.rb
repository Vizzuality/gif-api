# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Organization < ApplicationRecord
  has_many :organizations_projects, dependent: :nullify
  has_many :projects, through: :organizations_projects, dependent: :nullify
  validates :name, presence: true, uniqueness: true
end
