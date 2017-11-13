# esbreeden [10:09 AM]
# hey there - another P1st script - for NUMC, can you run a Submit click script for encounters in Admin status, with an RTE edit that hasn't been overridden and RTE status of Active?
p = Practice.find 111
apts = p.apts.where( :apt_status_id => AptStatus::PARTIALLY_CODED)
apts.each do |apt|
  Mde::Rules::Engine.run :encounter_edits, apt
  apt.reset_status
  apt.save
end
