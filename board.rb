require_relative 'tile'

class Board

  attr_accessor :grid, :num_bombs, :size

  def initialize(num_bombs, size = 9)
    @num_bombs = num_bombs
    @size = size
    @grid = Array.new(size) { Array.new(size) }
    make_tiles
  end

  def make_tiles
    #  make bomb tiles == num_bombs
    # make safe tiles == to gird.size - num_bombs

    tiles = []
    num_bombs.times do
      tile = Tile.new(self)
      tile.bomb = true
      tiles << tile
    end

    safe_tiles = (size ** 2) - num_bombs
    safe_tiles.times do
      tiles << Tile.new(self)
    end

    tiles.shuffle!

    grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        grid[idx1][idx2] = tiles.pop
      end
    end

  end

  def neighbors(pos)
    x, y = pos

    neighbor_coordinates = [
      [x+1, y], [x-1, y], [x, y+1], [x, y-1],
      [x+1, y+1], [x+1, y-1], [x-1, y+1], [x-1, y-1]
    ]

    neighbors = []

    neighbor_coordinates.each do |coordinate|
      if coordinate.first.between?(0, size) &&
        coordinate.last.between?(0, size)

        neighbors << coordinate
      end
    end

    neighbors
  end

  def assign_neighbors
    grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        grid[idx1][idx2].neighbors = neighbors([idx1, idx2])
      end
    end
  end

  def neighbor_bomb_count(pos)
    count = 0

    neighbors(pos).each do |coordinate|
      x, y = coordinate
      count += 1 if grid[x][y].bomb
    end

    count
  end



end
