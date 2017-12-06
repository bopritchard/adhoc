# esbreeden
# [3:30] so, REPROCESS RTE - all clients, RTE processed since 11/27, Medicare, Inactive - exclude apt status 23, 24, 6,7,8 and anything that has already been confirmed
# [3:31] additionally, if apt status is Partially Coded, POC or Admin - fire a Submit click - otherwise, don't Submit
# 1) for encounters that have been coded, we want the submit (which I think you have your arms around)
# 2) for encounters that are not coded (Scheduled/Arrived/etc...), we don't want to change the apt_status
conf.echo = false
total_count = 0
not_overriden_count = 0
run_rules_count = 0
status_reset = 0

apts = Apt.active.where("apt_status_id not in (23,24,6,7,8)").
          joins(:eligibility_messages).
          where( :eligibility_status_id => EligibilityStatus::INACTIVE).
          where("eligibility_messages.current = true").
          where("eligibility_messages.created_at > '2017-11-27'").
          where("apts.start < '2017-12-12'")
total_count = apts.count
apts.each do |apt|
  if apt.primary_is_medicare?
    total_count += 1
    if apt.apt_edits.where("apt_edits.rule_id = 23").where(override: false)
      not_overriden_count += 1
      apt_status_id = apt.apt_status_id
      Mde::Eligibility::EligibilityManager.check_apt apt, false

      if apt_status_id > 5
        run_rules_count += 1
        Mde::Rules::Engine.run :encounter_edits, apt
        apt.reset_status
        apt.save
      else
        status_reset += 1
        apt.apt_status_id = apt_status_id
        apt.sub_status_id = nil
        apt.save
      end
    end
  end

end

puts "total_count: #{total_count}"
puts "not_overriden_count: #{not_overriden_count}"
puts "run_rules_count: #{run_rules_count}"
puts "status_reset: #{status_reset}"
conf.echo = true
