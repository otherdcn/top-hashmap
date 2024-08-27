require_relative 'linked_list'

class HashMap
  attr_accessor :buckets

  def initialize
    self.buckets = Array.new(16) { LinkedList::Singly.new }
  end

  def hash(key)
    hash_code = 0
    prime_num = 31

    key.each_char { |char| hash_code = prime_num * hash_code + char.ord }

    hash_code
  end

  def set(key,value)
    hash_code = hash(key)
    index = hash_code % buckets.size

    buckets[index].append({key => value})
  end

  def get(key)
    hash_code = hash(key)
    index = hash_code % buckets.size

    node_index = buckets[index].find(key)

    node, _ = buckets[index].at(node_index)
    node.value[key]
  end
end
