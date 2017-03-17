# == Schema Information
#
# Table name: organizations_projects
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  project_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OrganizationsProject < ApplicationRecord
  belongs_to :organization
  belongs_to :project
end
