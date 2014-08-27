class PolyTreeNode
  attr_accessor :children
  attr_reader :value, :parent
  
  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end
  
  def parent=(parent)
    @parent.children.delete(self) if !@parent.nil? && @parent.children.include?(self) 
    @parent = parent
    @parent.children << self unless parent.nil?
  end
  
  def add_child(child_node)
    child_node.parent=(self)
  end
  
  def remove_child(child)
    raise "Node is not a child." unless self.children.include?(child)
    child.parent=(nil)
  end
  
  def dfs(value)
    return self if self.value == value
    
    #current_node = nil
    children.each do |child|
      node = child.dfs(value)
      return node unless node.nil?
      #current_node = node if node.value == value
    end
    nil
  end
  
  def bfs(value)
    queue = [self]
    
    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.value == value
      queue.concat(current_node.children)
    end
    nil
  end
  
  def inspect
    p "v: #{self.value}, c: #{self.children}"
  end

end

# if __FILE__ == $PROGRAM_NAME
#
#   nodes = ('a'..'g').map { |value| PolyTreeNode.new(value) }
#   parent_index = 0
#   nodes.each_with_index do |child, index|
#     next if index.zero?
#     child.parent = nodes[parent_index]
#     parent_index += 1 if index.even?
#   end
#
#   nodes.first.dfs('e')
#
# end