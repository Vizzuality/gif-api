# == Schema Information
#
# Table name: nature_based_solutions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NatureBasedSolution < ApplicationRecord
  has_and_belongs_to_many :projects, dependent: :nullify
  include Downcaseable
end
