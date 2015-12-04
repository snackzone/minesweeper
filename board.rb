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
      tiles << Tile.new("bomb")
    end

    safe_tiles = (size ** 2) - num_bombs
    safe_tiles.times do
      tiles << Tile.new("safe")
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



end
