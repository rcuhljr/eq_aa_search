require_relative 'aaloader.rb'

class_to_print = ARGV[0].to_s

#class_to_print = "Shadowknight"
#class_to_print = "Berserker"
#class_to_print = "Bard"
#class_to_print = "Necromancer"
#class_to_print = "Enchanter"
#class_to_print = "Shaman"

level_range = ARGV[1]..ARGV[2]
#level_range = 60..65

separator = "\t"

loader = AALoader.new(class_to_print)

level_range.each do |level| 
  aas = loader.aa_list[level.to_s]
  aas.each { |aa|  puts [aa[:level], aa[:name], aa[:rank], aa[:cost], aa[:text], aa[:prereqs]].join separator }
end