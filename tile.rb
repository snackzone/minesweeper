require_relative 'board'

class Tile

  NEIGHBORS = [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1],
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]

  attr_reader :flagged, :board
  attr_accessor :neighbors, :revealed, :bomb, :position, :display_value

  def initialize(board)
    @bomb = false
    @revealed = false
    @flagged = false
    @neighbors = []
    @display_value = "*"
    @board = board
    @position = []
  end

  def reveal
    raise "Cannot reveal flagged position" if flagged
    @revealed = true

    if bomb
      @display_value = "X"
    elsif neighbor_bomb_count > 0
      @display_value = neighbor_bomb_count.to_s
    else
      @display_value = "_"
    end
  end

  def flag
    raise "why would you flag a revealed position?" if revealed
    @flagged = true
    @display_value = "F"
    # need to add unflagging
  end

  def unflag
    @flagged = false
    @display_value = "*"
  end

  def find_neighbors
    neighbors = []

    cur_x, cur_y = position

    NEIGHBORS.each do |(dx, dy)|
      neighbor = [cur_x + dx, cur_y + dy]

      if neighbor.all? { |coord| coord.between?(0, board.size) }
        neighbors << neighbor
      end
    end

    neighbors
  end

  def neighbor_bomb_count
    count = 0

    self.find_neighbors.each do |coordinate|
      x, y = coordinate
      count += 1 if board.grid[x][y].bomb
    end

    count
  end

end
