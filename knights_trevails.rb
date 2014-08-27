require './00_tree_node'

class KnightPathFinder
  
  attr_accessor :visited_positions, :root_node
  attr_reader :start_pos
  
  def initialize(start_pos)
    @start_pos = start_pos
    @visited_positions = [start_pos]
    @root_node = PolyTreeNode.new(@start_pos)
  end
  
  def self.valid_moves(pos)
    valid_moves = []
    x_pos = pos.first 
    y_pos = pos.last
    valid_moves << [x_pos - 2, y_pos - 1]
    valid_moves << [x_pos - 2, y_pos + 1]
    valid_moves << [x_pos + 2, y_pos - 1]
    valid_moves << [x_pos + 2, y_pos + 1]
    valid_moves << [x_pos - 1, y_pos - 2]
    valid_moves << [x_pos - 1, y_pos + 2]
    valid_moves << [x_pos + 1, y_pos - 2]
    valid_moves << [x_pos + 1, y_pos + 2]
    
    valid_moves.select do |coords| 
      (0..7).include?(coords[0]) && (0..7).include?(coords[1])
    end
  end  
  
  def new_move_positions(pos)
    new_moves = self.class.valid_moves(pos).select do |move|
      !self.visited_positions.include?(move)
    end
    self.visited_positions.concat(new_moves)
    
    new_moves
  end
  
  def build_move_tree
    queue = [self.root_node]
    until queue.empty?
      current_move = queue.shift
      new_move_positions(current_move.value).each do |child|
        child_node = PolyTreeNode.new(child)
        current_move.add_child(child_node)
        queue << child_node
      end
    end
  end
  
  def find_path(end_pos)
    queue = [self.root_node]
    end_node = nil
    
    until queue.empty?
      current_node = queue.shift
      if current_node.value == end_pos
        end_node = current_node
        break
      end
      queue.concat(current_node.children)
    end
    
    result_path = [end_node.value]
    parent_node = end_node.parent
    until parent_node == nil
      result_path << parent_node.value
      parent_node = parent_node.parent
    end
    result_path.reverse!
  end
  
end

a = KnightPathFinder.new([0, 0])
a.build_move_tree
p a.find_path([7,6])
#p KnightPathFinder.valid_moves([0, 0])