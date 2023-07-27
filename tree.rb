require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def find(value)
    find_node(@root, value)
  end

  def insert(value)
    @root = insert_node(@root, value)
  end

  def delete(value)
    @root = delete_node(@root, value)
  end

  def level_order(&block)
    return level_order_array if block.nil?

    queue = [@root]
    while !queue.empty?
      node = queue.shift
      block.call(node)
      queue << node.left if node.left
      queue << node.right if node.right
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    return if node.nil?

    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def build_tree(array)
    return nil if array.empty?

    sorted_array = array.uniq.sort
    build_tree_helper(sorted_array, 0, sorted_array.length - 1)
  end

  def build_tree_helper(array, start_idx, end_idx)
    return nil if start_idx > end_idx

    mid = (start_idx + end_idx) / 2
    node = Node.new(array[mid])
    node.left = build_tree_helper(array, start_idx, mid - 1)
    node.right = build_tree_helper(array, mid + 1, end_idx)
    node
  end

  def find_node(root, value)
    return nil if root.nil?

    if value < root.data
      find_node(root.left, value)
    elsif value > root.data
      find_node(root.right, value)
    else
      root
    end
  end

  def insert_node(root, value)
    return Node.new(value) if root.nil?

    if value < root.data
      root.left = insert_node(root.left, value)
    elsif value > root.data
      root.right = insert_node(root.right, value)
    end

    root
  end

  def delete_node(root, value)
    return nil if root.nil?

    if value < root.data
      root.left = delete_node(root.left, value)
    elsif value > root.data
      root.right = delete_node(root.right, value)
    else
      if root.left.nil?
        return root.right
      elsif root.right.nil?
        return root.left
      end

      temp = find_min(root.right)
      root.data = temp.data
      root.right = delete_node(root.right, temp.data)
    end

    root
  end

  def find_min(node)
    node = node.left until node.left.nil?
    node
  end

  def level_order_array
    result = []
    level_order { |node| result << node.data }
    result
  end
end

# Example usage:
array = [50, 30, 70, 20, 40, 60, 80]
tree = Tree.new(array)

node = tree.find(40)
puts "Found node: #{node.data}" if node

puts "Binary Search Tree after insertions and deletions:"
tree.pretty_print

puts "Level-order traversal:"
tree.level_order { |node| puts node.data }

level_order_array = tree.level_order
puts "Level-order array: #{level_order_array.join(', ')}"
