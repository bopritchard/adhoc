# esbreeden
# Submit click for all clients, where RTE is Active and Edit exists (may not be any after your script last night, but let's check)

apts = Apt.active.
          joins( :eligibility_messages ).
          joins( "inner join (select apt_id from apt_edits where rule_id = 23 and override = false) as ae on ae.apt_id=apts.id" ).
          where( :eligibility_status_id => EligibilityStatus::PASSED).
          where( "eligibility_messages.created_at > '2017-11-27'")

apts.each do |apt|
  Mde::Rules::Engine.run :encounter_edits, apt
  apt.reset_status
  apt.save
end
