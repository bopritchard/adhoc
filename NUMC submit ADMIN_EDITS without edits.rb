count = 0
p = Practice.find 111
# apts = p.apts.where( 'apt_status_id NOT IN ( 1, 6, 7, 8,20, 23, 24, 25 )')
apts = p.apts.where( 'apt_status_id IN ( 21 )')
apts.each_with_index do |apt, i|
  Mde::Eligibility::EligibilityManager.check_apt apt, false
  Mde::Rules::Engine.run :encounter_edits, apt
  apt.reset_status
  apt.save
  count += 1 unless [21].include?(apt.apt_status_id)
  # count += 1 if [1, 6, 7, 8,20, 23, 24, 25].include?(apt.apt_status_id)
  if i % 10 == 0
    puts "---------------------------------------"
    puts "-----   Processed: #{i}        --------"
    puts "-----   Resolved: #{count}         --------"
    puts "---------------------------------------"
  end
end
