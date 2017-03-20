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

FactoryGirl.define do
  factory :location do
    adm0_code "MyString"
    adm0_name "MyString"
    adm1_code "MyString"
    adm1_name "MyString"
    adm2_code "MyString"
    adm2_name "MyString"
    iso "MyString"
    level 1
    region "MyString"
    centroid ""
  end
end
