require 'csv'
if CoBenefitsOfIntervention.all.size == 0
  bf = ['shoreline stabilization & accretion', 'employment, enterprise & property', 'public health','tourism & recreation', 'biodiversity', 'carbon sequestration', 'other ecosystem services']
  bf.each do |b|
    CoBenefitsOfIntervention.create!(name: b)
  end
  puts "co-benefits created"
end
if PrimaryBenefitsOfIntervention.all.size == 0
  bf = ['coastal energy management', 'redirection & drainage of flood & storm', 'water storage & infiltration of flood & storm water', 'wind speed reduction', 'landslides, erosion & siltation', 'control shoreline stabilization & accretion']
  bf.each do |b|
    PrimaryBenefitsOfIntervention.create!(name: b)
  end
  puts "primary benefits created"
end
if NatureBasedSolution.all.size == 0
  nbs = ['urban green spaces', 'forests & vegetation', 'rangelands', 'rivers & floodplains', 'terrestrial wetlands', 'coastal wetlands', 'dunes', 'mangroves', 'coral reefs & living shorelines', 'other']
  nbs.each do |n|
    NatureBasedSolution.create!(name: n)
  end
  puts "nature based solutions created"
end
if HazardType.all.size == 0
  ht = ['urban', 'river', 'coastal']
  ht.each do |h|
    HazardType.create!(name: h)
  end
  puts "hazard types created"
end
if Location.all.size == 0
  filename = File.expand_path(File.join(Rails.root, 'data', 'locations.csv'))
  CSV.foreach(filename, headers: true, col_sep: ";", encoding: 'ISO-8859-1') do |row|
    Location.create!(row.to_hash)
  end
  puts "locations created"
end

