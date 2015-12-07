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
    tiles = []

    (size**2).times do
      tiles << Tile.new(self)
    end

    tiles.sample(num_bombs).each { |tile| tile.bomb = true }

    grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        new_tile = tiles.pop
        new_tile.position = [idx1, idx2]
        self[idx1, idx2] = new_tile
      end
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, size) }
  end

  def reveal(pos)
    x, y = pos

    self[x, y].reveal
  end

  def flag(pos)
    x, y = pos

    self[x, y].flag
  end

  def [](x,y)
    @grid[x][y]
  end

  def []=(x,y,value)
    @grid[x][y] = value
  end

  def inspect
    grid.each do |row|
      row.map do |tile|
        tile.inspect
      end
    end
  end
end
