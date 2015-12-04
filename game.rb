require_relative 'board'
require_relative 'tile'
require_relative 'player'
require 'byebug'

class Game
  attr_reader :board, :player

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

  def take_turn
    puts "Enter R/F and coordinate"
    operation, coordinate = player.get_move.split(" ")
    coordinate = coordinate.split(",").map { |el| el.to_i }
    if operation == "r"
      reveal(coordinate)
    elsif operation == "f"
      flag(coordinate)
    elsif operation == "u"
      unflag(coordinate)
    end
    board.display
  end

  def reveal(pos)
    board.reveal(pos)
  end

  def flag(pos)
    board.flag(pos)
  end

  def unflag(pos)
    board.unflag(pos)
  end

end
