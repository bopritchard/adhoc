count = 0
p = Practice.find 111
apts = p.apts.where( :apt_status_id => AptStatus::ADMIN_EDITS)
apts.each do |apt|
  unless apt.has_edits?
    count += 1
    # Mde::Rules::Engine.run :encounter_edits, apt
    # apt.reset_status
    # apt.save
  end
end
puts count
