require_relative 'board'
require_relative 'tile'
require_relative 'player'
require 'byebug'

class Game
  attr_reader :board

  def initialize(player = Player.new)
    @player = player
    @board = Board.new(50, 9)
  end

  def new_game
    puts "board size?"
    size = gets.chomp.to_i

    puts "num of bombs?"
    num_bombs = gets.chomp.to_i

    @board = Board.new(num_bombs, size)
  end

  def display
    board_display = ""

    board.grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        current_tile = board.grid[idx1][idx2]
        # debugger
        if current_tile.revealed
          board_display += "_"
        else
          board_display += "*"
        end

      end
      board_display += "\n"
    end
    puts board_display
  end


  def reveal(pos)
    board.reveal(pos)
  end
end
