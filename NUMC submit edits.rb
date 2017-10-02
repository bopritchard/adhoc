# esbreeden [10:09 AM]
# hey there - another P1st script - for NUMC, can you run a Submit click script for encounters in Admin status, with an RTE edit that hasn't been overridden and RTE status of Active?
p = Practice.find 111
apts = p.apts.where( :apt_status_id => AptStatus::ADMIN_EDITS).where( :eligibility_status_id => 1).joins(:apt_edits).where("apt_edits.rule_id = 23 and apt_edits.override=false")
apts.each do |apt|
  Mde::Rules::Engine.run :encounter_edits, apt
  apt.reset_status
  apt.save
end
