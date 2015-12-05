require_relative 'board'
require_relative 'tile'
require_relative 'player'
require 'yaml'
require 'byebug'

class Game
  attr_reader :board, :player, :won, :time_elapsed

  def initialize(player = Player.new)
    @player = player
    @board = Board.new(10, 15)
    @won = false
    @time_elapsed = 0
  end

  def new_game
    puts "board size?"
    size = gets.chomp.to_i

    puts "num of bombs?"
    num_bombs = gets.chomp.to_i

    @board = Board.new(num_bombs, size)
  end

  def play
    set_timer

    take_turn until game_over?

    reveal_bombs
    refresh_screen
    puts won ? "you win!" : "try again!"
  end

  def take_turn
    refresh_screen

    operation, move = get_move

    if operation == "r"
      reveal(move)
    elsif operation == "f"
      flag(move)
    else
      raise "Invalid operation."
    end
  end

  def valid_move?(coordinate)
    (coordinate.length == 2) &&
    (coordinate.all? { |value| value.between?(0, board.size - 1) })
  end

  def game_over?
    tiles = board.grid.flatten
    return true if tiles.any? { |tile| tile.bomb && tile.revealed }

    non_bombs = tiles.reject { |tile| tile.bomb }
    if non_bombs.all? { |tile| tile.revealed }
      @won = true
      return true
    end

    false
  end

  def refresh_screen
    system("clear")
    update_timer
    puts "TIMER: #{time_elapsed}"
    board.display
  end

  def get_move
    puts "Enter r/f and coordinate"
    operation, coordinate = player.get_move.split(" ")
    operation.downcase!
    coordinate = coordinate.split(",").map { |el| el.to_i }

    raise "invalid move!" unless valid_move?(coordinate)

    [operation, coordinate]
  end

  def reveal_bombs
    board.grid.flatten.select{ |tile| tile.bomb }.each do |bomb|
      bomb.reveal
    end
  end

  def reveal(pos)
    board.reveal(pos)
  end

  def flag(pos)
    board.flag(pos)
  end

  def set_timer
    @start_time = Time.now
    @time_elapsed = 0
  end

  def update_timer
    @time_elapsed = (Time.now - @start_time).floor
  end

  def inspect
    "#{board.size}:#{board.num_bombs}:#{time_elapsed}"
  end

  def save
    File.open("saved_games.txt", "w") do |file|
      #add file to save files self.to_yaml
    end
  end

  def load
    File.open("saved_games.txt", "r") do |file|
      #load file by YAML.parse(file)
    end
  end
end
