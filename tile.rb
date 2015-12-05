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
    self.revealed = true

    if neighbor_bomb_count == 0
      find_neighbors.each do |neighbor|
        x, y = neighbor
        tile = board[x, y]
        tile.reveal unless tile.revealed
      end
    end


  end

  def to_s
    return display_value if !revealed

    if revealed
      if bomb
        @display_value = "X"
      elsif neighbor_bomb_count > 0
        @display_value = neighbor_bomb_count.to_s
      else
        @display_value = "_"
      end
    end

    display_value
  end

  def flag
    raise "that position is already revealed." if revealed

    if flagged
      @flagged = false
      @display_value = "*"
    else
      @flagged = true
      @display_value = "F"
    end
  end

  def find_neighbors
    neighbors = []

    cur_x, cur_y = position

    NEIGHBORS.each do |(dx, dy)|
      neighbor = [cur_x + dx, cur_y + dy]

      if neighbor.all? { |value| value.between?(0, board.size - 1) }
        neighbors << neighbor
      end
    end

    neighbors
  end

  def neighbor_bomb_count
    count = 0

    self.find_neighbors.each do |coordinate|
      x, y = coordinate
      count += 1 if board[x,y].bomb
    end

    count
  end

  def inspect
    @display_value
  end
end
