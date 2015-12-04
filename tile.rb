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
  attr_accessor :neighbors, :revealed, :bomb, :position

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
    revealed = true
  end

  def display
    # unless revealed
    #   @display_value
    # end
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
      count += 1 if grid[x][y].bomb
    end

    count
  end

end
