require_relative 'tic_tac_toe'

class TicTacToeNode
  
  attr_accessor :board, :next_mover_mark, :prev_move_pos
  
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    next_moves = []
    self.board.rows.each_with_index do |row, row_index|
      row.each_index do |col|
        if self.board.empty?([row_index, col])
          new_board = self.board.dup
          new_board.[]=([row_index, col], self.next_mover_mark)
          next_moves << TicTacToeNode.new(new_board, ((self.next_mover_mark == :x) ? :o : :x), [row_index, col])
        end
      end
    end
    next_moves
  end

  def losing_node?(evaluator)
    return self.board.winner == ((evaluator == :x) ? :o : :x) if self.children.empty?
    # my turn
    unless self.next_mover_mark == evaluator
      self.children.all? do |child|
        child.losing_node?(evaluator)
      end
    # human turn
    else
      self.children.any? do |child|
        child.losing_node?(evaluator)
      end
    end
  end

  def winning_node?(evaluator)
    return self.board.winner == evaluator if self.children.empty?
    unless @next_mover_mark == evaluator
      self.children.any? do |child|
        child.winning_node?(evaluator)
      end
    else
      self.children.all? do |child|
        child.winning_node?(evaluator)
      end
    end
  end
end

if __FILE__==$PROGRAM_NAME
  board = Board.new([
    [:o, nil, :o],
    [nil, nil, nil],
    [nil, nil, :o]
  ])
  
  node = TicTacToeNode.new(board, :x)
  p node.losing_node?(:o) #true
  p node.winning_node?(:x) #true
end

