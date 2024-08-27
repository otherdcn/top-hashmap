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

  def get_index(key)
    hash_code = hash(key)
    hash_code % buckets.size
  end

  def set(key,value)
    index = get_index(key)
    buckets[index].append({key => value})
  end

  def get(key)
    index = get_index(key)

    node_index = buckets[index].find(key)
    return nil if node_index.nil?

    node, _ = buckets[index].at(node_index)
    return nil if node.nil?

    node.value[key]
  end

  def has?(key)
    index = get_index(key)
    buckets[index].contains(key)
  end

  def remove(key)
    index = get_index(key)

    node_index = buckets[index].find(key)
    return nil if node_index.nil?

    removed_node = buckets[index].remove_at(node_index)
    removed_node.value[key]
  end
end
