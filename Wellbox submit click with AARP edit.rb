count = 0
p = Practice.find 124
apts = p.apts.where( 'apt_status_id IN ( 21 )').joins(:apt_edits).where('apt_edits.rule_id=72 and override is false')

apts.each_with_index do |apt,i|
  Mde::Rules::Engine.run :encounter_edits, apt
  apt.reset_status
  apt.save
  count += 1 unless [21].include?(apt.apt_status_id)
  if i % 10 == 0
    puts "---------------------------------------"
    puts "-----   Processed: #{i}        --------"
    puts "-----   Resolved: #{count}         --------"
    puts "---------------------------------------"
  end
end
