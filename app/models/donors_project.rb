# == Schema Information
#
# Table name: donors_projects
#
#  id         :integer          not null, primary key
#  donor_id   :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DonorsProject < ApplicationRecord
  belongs_to :donor
  belongs_to :project
end
