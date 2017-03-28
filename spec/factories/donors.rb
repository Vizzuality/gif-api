# == Schema Information
#
# Table name: donors
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :donor do
    name "MyString"
  end
end
