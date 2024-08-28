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

  def length
    size = 0
    buckets.each { |bucket| size += bucket.size }
    size
  end

  def clear
    buckets.each { |bucket| bucket.clear }
    0
  end

  def entries
    all_entries = []

    buckets.each_with_index do |bucket,idx|
      next if bucket.traverse.nil?

      all_entries.concat(bucket.traverse[1])
    end

    all_entries
  end

  def keys
    all_entries = entries
    all_keys = []

    all_entries.each do |entry|
      all_keys.push(entry[0])
    end

    all_keys
  end

  def values
    all_entries = entries
    all_values = []

    all_entries.each do |entry|
      all_values.push(entry[1])
    end

    all_values
  end
end
