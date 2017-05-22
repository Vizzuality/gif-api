# == Schema Information
#
# Table name: currencies
#
#  id   :integer          not null, primary key
#  iso  :string
#  name :string
#

FactoryGirl.define do
  factory :currency do
    iso ""
    name "MyString"
  end
end
