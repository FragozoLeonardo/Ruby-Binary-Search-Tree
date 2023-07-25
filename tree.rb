require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
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

  public

  def print_tree(node = root, level = 0)
    return if node.nil?

    print_tree(node.right, level + 1)
    puts "  " * level + node.data.to_s
    print_tree(node.left, level + 1)
  end
end

array = [50, 30, 70, 20, 40, 60, 80]
tree = Tree.new(array)

puts "Binary Search Tree:"
tree.print_tree
