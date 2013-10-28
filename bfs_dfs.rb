module Searches
  def dfs(target = nil, &prc)
    if block_given?
      return self if prc.call(self)
    else
      return self if value == target
    end

    children.each do |child|
      next if child.nil?

      result = child.dfs(target, &prc)
      return result unless result.nil?
    end

    nil
  end

  def bfs(target = nil, &prc)
    nodes = [self]
    until nodes.empty?
      node = nodes.shift

      if block_given?
        return node if prc.call(node)
      else
        return node if node.value == target
      end

      nodes.concat(node.children)
    end

    nil
  end
end

class Node
  include Searches

  attr_accessor :value
  attr_reader :parent

  def initialize(value = nil)
    @value = value
    @parent = nil
    @children = []
  end

  def children
    # dup to avoid inadvertantly adding/removing a child
    # modifications to "node.children" do not actually persist
    @children.dup
  end

  def add_child(new_child)
    @children << new_child
    new_child.parent = self
  end

  def remove_child(child)
    @children.delete(child)
    child.parent = nil
  end

  protected
  attr_writer :parent
end


# seed data
root = Node.new(0)
one = Node.new(1)
root.add_child(one)
two = Node.new(2)
root.add_child(two)
three = Node.new(3)
one.add_child(three)
four = Node.new(4)
one.add_child(four)
five = Node.new(5)
two.add_child(five)
six = Node.new(6)
two.add_child(six)
seven = Node.new(7)
three.add_child(seven)
eight = Node.new(8)
three.add_child(eight)
nine = Node.new(9)
four.add_child(nine)
ten = Node.new(10)
four.add_child(ten)
eleven = Node.new(11)
five.add_child(eleven)
twelve = Node.new(12)
five.add_child(twelve)
thirteen = Node.new(13)
six.add_child(thirteen)
fourteen = Node.new(14)
six.add_child(fourteen)


def time_test(root)
  bfs_time = 0
  dfs_time = 0
  targets = []

  20.times {
    target = rand(15)
    targets << target

    bfs_start = Time.now
    root.bfs(target)
    bfs_end = Time.now
    bfs_time += (bfs_end - bfs_start)

    dfs_start = Time.now
    root.dfs(target)
    dfs_end = Time.now
    dfs_time += (dfs_end - dfs_start)
  }

  puts "          0 (root)    "
  puts '         /  \         '
  puts '        /    \        '
  puts '       /      \       '
  puts '      /        \      '
  puts "     1          2     "
  puts '    /\         / \    '
  puts '   /  \       /   \   '
  puts "  3    4     5     6  "
  puts ' / \  / \   / \   / \ '
  puts "7  8  9 10 11 12 13 14"
  puts ""
  puts "targets:"
  p targets
  puts "Breadth-first search took #{bfs_time} seconds,\nwhile Depth-first search took #{dfs_time}."
end

loop {
  puts "\nhit enter to run the test"
  gets
  time_test(root)
}
