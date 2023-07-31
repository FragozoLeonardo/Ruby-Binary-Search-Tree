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

  def inorder(node = @root, &block)
    return inorder_array if block.nil?

    return if node.nil?

    inorder(node.left, &block)
    block.call(node)
    inorder(node.right, &block)
  end

  def preorder(node = @root, &block)
    return preorder_array if block.nil?

    return if node.nil?

    block.call(node)
    preorder(node.left, &block)
    preorder(node.right, &block)
  end

  def postorder(node = @root, &block)
    return postorder_array if block.nil?

    return if node.nil?

    postorder(node.left, &block)
    postorder(node.right, &block)
    block.call(node)
  end

  def height(node = @root)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    [left_height, right_height].max + 1
  end

  def pretty_print(node = root, prefix = '', is_left = true)
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

  def inorder_array
    result = []
    inorder { |node| result << node.data }
    result
  end

  def preorder_array
    result = []
    preorder { |node| result << node.data }
    result
  end

  def postorder_array
    result = []
    postorder { |node| result << node.data }
    result
  end

  def level_order_array
    result = []
    level_order { |node| result << node.data }
    result
  end
end

array = [50, 30, 70, 20, 40, 60, 80]
tree = Tree.new(array)

puts "Binary Search Tree after insertions and deletions:"
tree.pretty_print

puts "Inorder traversal:"
tree.inorder { |node| puts node.data }

puts "Preorder traversal:"
tree.preorder { |node| puts node.data }

puts "Postorder traversal:"
tree.postorder { |node| puts node.data }

puts "Height of the root node: #{tree.height}"

print "Enter a value to find the node's height: "
value = gets.chomp.to_i

node = tree.find(value)

if node
  puts "Height of the node with value #{value}: #{tree.height(node)}"
else
  puts "Node with value #{value} not found in the tree."
end
