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
        new_tile = tiles.pop
        new_tile.position = [idx1, idx2]
        grid[idx1][idx2] = new_tile
      end
    end
  end

  def display
    board_display = ""

    grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        current_tile = grid[idx1][idx2]
        if current_tile.revealed
          board_display += "_"
        elsif current_tile.flagged
          board_display += "F"
        else
          board_display += "*"
        end

      end
      board_display += "\n"
    end
    puts board_display
  end

  def reveal(pos)
    x, y = pos

    grid[x][y].reveal
  end

  def flag(pos)
    x, y = pos

    grid[x][y].flag
  end

end
