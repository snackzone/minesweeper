require_relative 'board'
require_relative 'tile'
require_relative 'player'

class Game
  attr_reader :board

  def initialize(player = Player.new)
    @player = player
  end

  def new_game
    puts "board size?"
    size = gets.chomp.to_i

    puts "num of bombs?"
    num_bombs = gets.chomp.to_i

    @board = Board.new(num_bombs, size)
  end

  def display
    board = ""

    board.grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        current_tile = board.grid[idx1][idx2]
        if current_tile.revealed
          board += "_"
        else
          board += "*"
        end

      end
      board += "\n"
    end
  end


  def reveal(pos)
    x, y = pos
    #find Tile instance at pos
    current_tile = board.grid[x][y]

    current_tile.reveal

  end
end
