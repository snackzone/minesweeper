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

end
