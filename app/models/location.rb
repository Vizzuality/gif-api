# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  adm0_code  :string
#  adm0_name  :string
#  adm1_code  :string
#  adm1_name  :string
#  adm2_code  :string
#  adm2_name  :string
#  iso        :string
#  level      :integer
#  region     :string
#  centroid   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Location < ApplicationRecord
  has_and_belongs_to_many :projects, dependent: :nullify
end
