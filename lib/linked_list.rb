module LinkedList
  class SinglyLinkedNode
    attr_accessor :value, :next_node

    def initialize(value)
      self.value = value
      self.next_node = nil
    end
  end

  class DoublyLinkedNode < SinglyLinkedNode
    attr_accessor :previous_node

    def initialize(value)
      super value
      self.previous_node = nil
    end
  end

  LINKED_LIST_TYPE = {
    singly_linked: SinglyLinkedNode,
    doubly_linked: DoublyLinkedNode
  }

  class Singly
    attr_accessor :head, :tail, :size

    def initialize
      self.head = nil
      self.tail = nil
      self.size = 0
    end

    def empty?
      head.nil?
    end

    def append(value, type = :singly_linked)
      node = LINKED_LIST_TYPE[type].new(value)

      if empty?
        self.head = node
        self.tail = node # I am considering one element in the list as both a head and a tail
      else
        self.tail.next_node = node
        self.tail = node
      end
      self.size += 1

      node
    end

    def prepend(value, type = :singly_linked)
      node = LINKED_LIST_TYPE[type].new(value)

      if empty?
        self.head = node
        self.tail = node # I am considering one element in the list as both a head and a tail
      else
        node.next_node = head
        self.head = node
      end
      self.size += 1

      node
    end

    def at(index)
      return nil if empty?

      raise IndexError, "Index out of bounds (#{index} > #{size})" if index > size
      return [head, nil] if index == 1

      node = head
      previous_node = nil
      for i in 1...index
        parent_node = node
        node = node.next_node
      end

      [node, parent_node]
    end

    def pop
      return nil if empty?

      popped_node = tail # if only one element left in list, then tail will be pointing to head node as well
      self.tail = at(size-1)[0]
      self.tail.next_node = nil
      self.size -= 1

      popped_node
    end

    def shift
      return nil if empty?

      shifted_node = head
      self.head = head.next_node
      shifted_node.next_node = nil
      self.tail = nil if shifted_node == tail # in case of deleting the only node in list
      self.size -= 1

      shifted_node
    end

    def search(value)
      node = head
      index = 1

      until node.nil?
        if node.value.has_key? value
          return [true, node, index]
        else
          node = node.next_node
          index += 1
        end
      end

      [false, nil, nil]
    end

    def contains(value)
      node_exist, node, index = search(value)

      node_exist
    end

    def find(value)
      node_exist, node, index = search(value)

      index
    end

    def traverse
      return "" if empty?

      node = head
      traversal = ""

      traversal << "( #{node.value} ) -> "
      while node.next_node != nil
        node = node.next_node
        traversal << "( #{node.value} ) -> "
      end
      traversal << "nil.\n"
    end

    def to_s
      return traverse
    end

    def insert_at(value, index, type = :singly_linked)
      return nil if empty?

      raise IndexError, "Index out of bounds (#{index} > #{size})" if index > size

      node_at_index, predecessor = at(index)

      return prepend(value) if node_at_index == head

      node = LINKED_LIST_TYPE[type].new(value)
      predecessor.next_node = node
      node.next_node = node_at_index
      self.size += 1

      node
    end

    def remove_at(index)
      return nil if empty?

      raise IndexError, "Index out of bounds (#{index} > #{size})" if index > size

      node_at_index, predecessor = at(index)

      if node_at_index == head
        self.head = head.next_node
        node_at_index.next_node = nil
        self.tail = nil if node_at_index == tail # in case of deleting the only node in list

        self.size -= 1
      elsif node_at_index == tail
        self.pop
      else
        predecessor.next_node = node_at_index.next_node
        node_at_index.next_node = nil

        self.size -= 1
      end

      node_at_index
    end

    def each
      return nil if empty?

      node = head

      until node.nil?
        yield node

        node = node.next_node
      end
    end

    def reverse
      return nil if empty?

      new_linked_list = LinkedList.new

      self.each { |node| new_linked_list.prepend(node.value) }

      new_linked_list
    end

    def reverse!
      return nil if empty?

      list_size = size
      temp_head = shift

      self.tail = temp_head

      until empty?
        node = shift

        node.next_node = temp_head

        temp_head = node
      end

      self.size = list_size
      self.head = temp_head
    end

    def examine_node(index)
      node_at_index, _ = at(index)
      node = node_at_index.value
      next_node = node_at_index.next_node ? node_at_index.next_node.value : "null"

      "Node: #{node}\nNext: #{next_node}"
    end

    def clear
      self.head = nil
      self.tail = nil
      self.size = 0
    end

    private :search
  end

  class Doubly < Singly
    def append(value, type = :doubly_linked)
      node = LINKED_LIST_TYPE[type].new(value)

      if empty?
        self.head = node
        self.tail = node # I am considering one element in the list as both a head and a tail
      else
        node.previous_node = tail
        self.tail.next_node = node
        self.tail = node
      end
      self.size += 1

      node
    end

    def prepend(value, type = :doubly_linked)
      node = LINKED_LIST_TYPE[type].new(value)

      if empty?
        self.head = node
        self.tail = node # I am considering one element in the list as both a head and a tail
      else
        node.next_node = head
        self.head.previous_node = node
        self.head = node
      end
      self.size += 1

      node
    end

    def pop
      return nil if empty?

      popped_node = tail # if only one element left in list, then tail will be pointing to head node as well

      self.tail = tail.previous_node
      self.tail.next_node = nil

      popped_node.next_node = nil
      popped_node.previous_node = nil

      self.size -= 1

      popped_node
    end

    def shift
      return nil if empty?

      shifted_node = head
      self.head = head.next_node
      self.head.previous_node = nil if head
      shifted_node.next_node = nil
      self.tail = nil if shifted_node == tail # in case of deleting the only node in list
      self.size -= 1

      shifted_node
    end

    def at(index)
      return nil if empty?

      raise IndexError, "Index out of bounds (#{index} > #{size})" if index > size
      return head if index == 1

      node = head
      for i in 1...index
        node = node.next_node
      end

      node
    end

    def insert_at(value, index, type = :doubly_linked)
      return nil if empty?

      raise IndexError, "Index out of bounds (#{index} > #{size})" if index > size

      node_at_index = at(index)

      return prepend(value) if node_at_index == head

      node = LINKED_LIST_TYPE[type].new(value)

      node_at_index.previous_node.next_node = node
      node.previous_node = node_at_index.previous_node
      node.next_node = node_at_index
      node_at_index.previous_node = node
      self.size += 1

      node
    end

    def remove_at(index)
      return nil if empty?

      raise IndexError, "Index out of bounds (#{index} > #{size})" if index > size

      node_at_index = at(index)

      if node_at_index == head
        self.head = head.next_node
        self.head.previous_node = nil
        node_at_index.next_node = nil

        self.tail = nil if node_at_index == tail # in case of deleting the only node in list

        self.size -= 1
      elsif node_at_index == tail
        self.pop
      else
        node_at_index.previous_node.next_node = node_at_index.next_node
        node_at_index.next_node.previous_node = node_at_index.previous_node
        node_at_index.previous_node = nil
        node_at_index.next_node = nil

        self.size -= 1
      end

      node_at_index
    end

    def reverse
      raise StandardError, "The reverse method is not yet avaialble for Doubly class"
    end

    def reverse!
      raise StandardError, "The reverse! method is not yet avaialble for Doubly class"
    end

    def examine_node(index)
      node_at_index = at(index)
      node = node_at_index.value
      previous_node = node_at_index.previous_node ? node_at_index.previous_node.value : "null"
      next_node = node_at_index.next_node ? node_at_index.next_node.value : "null"

      "Node: #{node}\nPrevious: #{previous_node}\nNext: #{next_node}"
    end
  end
end

