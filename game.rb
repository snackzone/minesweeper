require_relative 'board'
require_relative 'tile'
require_relative 'player'
require 'byebug'

class Game
  attr_reader :board, :player

  def initialize(player = Player.new)
    @player = player
    @board = Board.new(50, 9)
    #@won = false
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

    #evaluate the game result
  end

  def take_turn
    puts "Enter R/F/U and coordinate"
    operation, coordinate = player.get_move.split(" ")
    operation = operation.downcase
    coordinate = coordinate.split(",").map { |el| el.to_i }
    if operation == "r"
      reveal(coordinate)
    elsif operation == "f"
      flag(coordinate)
    elsif operation == "u"
      unflag(coordinate)
    else
      raise "Invalid move."
    end
    board.display
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

  def unflag(pos)
    board.unflag(pos)
  end

end
