require_relative 'board'
require 'colorize'

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

  TILE_DISPLAYS = {
    unrevealed: "*".colorize(:yellow),
    empty: "_".colorize(:blue),
    flagged: "F".colorize(:red),
    bomb: "X".colorize(:red),
    neighbor_bomb_count: :white
  }

  attr_reader :board
  attr_accessor :neighbors, :revealed, :bomb, :position, :display_value,
  :flagged

  def initialize(board)
    @bomb = false
    @revealed = false
    @flagged = false
    @neighbors = []
    @display_value = TILE_DISPLAYS[:unrevealed]
    @board = board
    @position = []
  end

  def reveal
    unless self.flagged
      self.revealed = true

      if neighbor_bomb_count == 0
        find_neighbors.each do |neighbor|
          x, y = neighbor
          tile = board[x, y]
          tile.reveal unless tile.revealed
        end
      end
    end
  end

  def to_s
    return display_value if !revealed

    if revealed
      if bomb
        display_value = TILE_DISPLAYS[:bomb]
      elsif neighbor_bomb_count > 0
        display_value = neighbor_bomb_count.to_s.colorize(TILE_DISPLAYS[:neighbor_bomb_count])
      else
        display_value = TILE_DISPLAYS[:empty]
      end
    end

    display_value
  end

  def flag
    if flagged
      @flagged = false
      @display_value = TILE_DISPLAYS[:unrevealed]
    elsif !revealed
      @flagged = true
      @display_value = TILE_DISPLAYS[:flagged]
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
