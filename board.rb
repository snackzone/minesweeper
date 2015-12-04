require_relative 'tile'

class Board

  attr_accessor :grid, :num_bombs, :size

  def initialize(num_bombs, size = 9)
    @num_bombs = num_bombs
    @size = size
    @grid = Array.new(size) { Array.new(size) }
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

    grid.map do |row|
      row.map do |tile|
        tiles.pop
      end
    end
  end



end
