require_relative "linked_list"

class HashMap
  attr_accessor :buckets
  attr_reader :buckets_capacity

  LOAD_FACTOR = 0.75

  def initialize
    @buckets_capacity = 16
    self.buckets = Array.new(buckets_capacity) { LinkedList::Singly.new }
  end

  def max_capacity
    @max_capacity = (buckets_capacity * LOAD_FACTOR).ceil
  end

  def hash(key)
    hash_code = 0
    prime_num = 31

    key.each_char { |char| hash_code = (prime_num * hash_code) + char.ord }

    hash_code
  end

  def get_index(key)
    hash_code = hash(key)
    hash_code % buckets.size
  end

  def set(key, value)
    index = get_index(key)
    return update(key, value, index) if has?(key)

    grow_hashmap if length == max_capacity

    buckets[index].append({ key => value })
  end

  def update(key, value, index)
    node_index = buckets[index].find(key)

    node, = buckets[index].at(node_index)
    node.value = { key => value }

    get(key)
  end

  def get(key)
    index = get_index(key)

    node_index = buckets[index].find(key)
    return nil if node_index.nil?

    node, = buckets[index].at(node_index)
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
    buckets.each(&:clear)
    0
  end

  def entries
    all_entries = []

    buckets.each_with_index do |bucket, _idx|
      next if bucket.traverse.nil?

      all_entries.concat(bucket.traverse[1])
    end

    all_entries
  end

  def keys
    all_entries = entries
    all_entries.map do |entry|
      entry[0]
    end
  end

  def values
    all_entries = entries
    all_entries.map do |entry|
      entry[1]
    end
  end

  def grow_hashmap
    all_entries = entries
    clear

    @buckets_capacity *= 2
    self.buckets = Array.new(buckets_capacity) { LinkedList::Singly.new }

    all_entries.each do |entry|
      key, value = entry
      set(key, value)
    end
  end

  def to_s
    string_to_print = ""
    buckets.each_with_index do |bucket, idx|
      string_to_print << "Checking bucket (#{bucket.size}) #{idx}: "
      string_to_print << if bucket.empty?
                           "Empty!\n"
                         else
                           "===> #{bucket}"
                         end
    end

    string_to_print
  end

  private :update, :hash, :grow_hashmap, :max_capacity
end
