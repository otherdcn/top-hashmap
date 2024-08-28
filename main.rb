require_relative 'lib/hashmap'

data = [
  ['apple', 'red'],
  ['banana', 'yellow'],
  ['carrot', 'orange'],
  ['dog', 'brown'],
  ['elephant', 'gray'],
  ['frog', 'green'],
  ['grape', 'purple'],
  ['hat', 'black'],
  ['ice cream', 'white'],
  ['jacket', 'blue'],
  ['kite', 'pink'],
  ['lion', 'golden']
]

test = HashMap.new

data.each do |item|
  fruit, colour = item
  test.set(fruit, colour)
end


operations = [
  'Quit/Exit program',
  'Set to HashMap',
  'Update key in HashMap',
  'Get value for key from HashMap',
  'Get index for key from HashMap',
  'Remove key/value pair from HashMap',
  'Check if HashMap has key',
  "Check HashMap's length",
  'Check all key/value pair entries',
  'Check all keys from HashMap',
  'Check all values from HashMap',
  'Clear key/value pair entries from HashMap'
]

operation = 1

until operation.zero?
  operations.each_with_index do |operation, index|
    puts "#{index}. ".ljust(4) + operation
  end

  print "\n==> Select one of the above operations [type 0-11]: "
  operation = gets.chomp.to_i

  puts ""

  begin
    case operation
    when 0
      puts "Ending program"
    when 1
      puts operations[operation]

      print "Enter key/value pair (comma separted): "
      user_key_value_pair = gets.chomp.split(",")
      key, value = user_key_value_pair

      result = test.set(key,value)

      outcome = result.instance_of?(LinkedList::SinglyLinkedNode) ? "set" : "updated"
      puts "#{key} #{outcome}!"
    when 2
      puts operations[operation]

      print "Enter key/value pair (comma separted): "
      user_key_value_pair = gets.chomp.split(",")
      key, value = user_key_value_pair

      test.set(key,value)
      puts "#{key} updated!"
    when 3
      puts operations[operation]

      print "Enter key: "
      user_key = gets.chomp

      value = test.get(user_key)
      puts "#{user_key}: #{value}"
    when 4
      puts operations[operation]

      print "Enter key: "
      user_key = gets.chomp

      puts "#{user_key} index: #{test.get_index(user_key)}"
    when 5
      puts operations[operation]

      print "Enter key: "
      user_key = gets.chomp

      removed_key_value = test.remove(user_key)

      puts "#{user_key}: #{removed_key_value} has been removed"
    when 6
      puts operations[operation]

      print "Enter key: "
      user_key = gets.chomp

      puts "#{user_key} present: #{test.has?(user_key)}"
    when 7
      puts operations[operation]

      puts "Size: #{test.length}"
    when 8
      puts operations[operation]

      all_entries = test.entries
      puts "Empty HashMap!" if all_entries.empty?

      all_entries.each do |entry|
        puts "#{entry[0]}: #{entry[1]}"
      end
    when 9
      puts operations[operation]

      all_keys = test.keys
      puts "Empty HashMap!" if all_keys.empty?

      all_keys.each do |entry|
        puts "#{entry}"
      end
    when 10
      puts operations[operation]

      all_values = test.values
      puts "Empty HashMap!" if all_values.empty?

      all_values.each do |entry|
        puts "#{entry}"
      end
    when 11
      puts operations[operation]

      result = test.clear
      puts "HashMap clear!" if result.zero?
    else
      puts "Unknown operation; enter 0-#{operations.size}"
    end
  rescue StandardError => e
    puts e
  end

  puts "\n------------------------------------------\n\n"
end
