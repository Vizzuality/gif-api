if CoBenefitsOfIntervention.all.size == 0
  bf = ['shoreline stabilization & accretion', 'employment, enterprise & property', 'public health','tourism & recreation', 'biodiversity', 'carbon sequestration', 'other ecosystem services']
  bf.each do |b|
    CoBenefitsOfIntervention.create!(name: b)
  end
end
if PrimaryBenefitsOfIntervention.all.size == 0
  bf = ['coastal energy management', 'redirection & drainage of flood & storm', 'water storage & infiltration of flood & storm water', 'wind speed reduction', 'landslides, erosion & siltation', 'control shoreline stabilization & accretion']
  bf.each do |b|
    PrimaryBenefitsOfIntervention.create!(name: b)
  end
end
if NatureBasedSolution.all.size == 0
  nbs = ['urban green spaces', 'forests & vegetation', 'rangelands', 'rivers & floodplains', 'terrestrial wetlands', 'coastal wetlands', 'dunes', 'mangroves', 'coral reefs & living shorelines', 'other']
  nbs.each do |n|
    NatureBasedSolution.create!(name: n)
  end
end
if HazardType.all.size == 0
  ht = ['urban', 'river', 'coastal']
  ht.each do |h|
    HazardType.create!(name: h)
  end
end