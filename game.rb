require_relative 'board'
require_relative 'tile'
require_relative 'player'
require 'byebug'

class Game
  attr_reader :board, :player, :won

  def initialize(player = Player.new)
    @player = player
    @board = Board.new(10, 15)
    @won = false
  end

  def new_game
    puts "board size?"
    size = gets.chomp.to_i

    puts "num of bombs?"
    num_bombs = gets.chomp.to_i

    @board = Board.new(num_bombs, size)
  end

  def play
    take_turn until game_over?

    if won
      puts "you win!"
    else
      puts "try again!"
    end
  end

  def take_turn
    puts "Enter f/u and coordinate"
    operation, coordinate = player.get_move.split(" ")
    operation.downcase!
    coordinate = coordinate.split(",").map { |el| el.to_i }

    raise "invalid move!" unless valid_move?(coordinate)

    if operation == "r"
      reveal(coordinate)
    elsif operation == "f"
      flag(coordinate)
    else
      raise "Invalid operation."
    end

    board.display
  end

  def valid_move?(coordinate)
    (coordinate.length == 2) &&
    (coordinate.all? { |value| value.between?(0, board.size - 1) })
  end

  def game_over?
    tiles = board.flatten
    #if board contains any revealed bombs
    if tiles.any? { |tile| tile.bomb && tile.revealed }
      return true
    end

    #if board does not contain any non-revealed non-bombs
    if tiles.all? { |tile| !tile.bomb && tile.revealed }
      @won = true
      return true
    end

    false
  end

  def reveal(pos)
    board.reveal(pos)
  end

  def flag(pos)
    board.flag(pos)
  end
end
