require 'csv'
if CoBenefitsOfIntervention.all.size == 0
  bf = ["agriculture, fisheries & forestry income", "employment, enterprise & property", "public health", "tourism & recreation", "biodiversity", "carbon sequestration", "other"]
  bf.each do |b|
    CoBenefitsOfIntervention.create!(name: b)
  end
  puts "co-benefits created"
end
if PrimaryBenefitsOfIntervention.all.size == 0
  bf = ["coastal energy management", "shoreline stabilization & accretion", "wind speed reduction", "redirection & drainage of flood & storm water", "storage & infiltration of flood & storm water", "reduced infrastructure loss", "slope stabilization", "soil composition maintained", "groundwater recharge & water table stabilization", "other"]
  bf.each do |b|
    PrimaryBenefitsOfIntervention.create!(name: b)
  end
  puts "primary benefits created"
end
if NatureBasedSolution.all.size == 0
  nbs = ["urban green spaces", "forests & vegetation", "rivers & floodplains", "terrestrial wetlands", "coastal wetlands", "dunes", " mangroves", "coral reefs and living shorelines", "other"]
  nbs.each do |n|
    NatureBasedSolution.create!(name: n)
  end
  puts "nature based solutions created"
end
if HazardType.all.size == 0
  ht = ["urban flooding", "river flooding", "coastal flooding", "landslides", "drought"]
  ht.each do |h|
    HazardType.create!(name: h)
  end
  puts "hazard types created"
end
if Location.all.size == 0
  filename = File.expand_path(File.join(Rails.root, 'data', 'locations.csv'))
  CSV.foreach(filename, headers: true, col_sep: ",", encoding: 'ISO-8859-1') do |row|
    Location.create!(row.to_hash)
  end
  puts "locations created"
end

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if AdminUser.all.size == 0