require_relative 'board'
require_relative 'tile'
require 'yaml'
require 'byebug'
require 'colorize'

class Game
  DISPLAY_COLOR = :green

  def self.load
    puts "loading saved game...".colorize(DISPLAY_COLOR)
    sleep(1)

    loaded_game = YAML.load_file("SAVED_GAME.yml")
    loaded_game.play
  end

  def self.new_game
    Game.new.play
  end

  attr_reader :board, :player, :won, :time_elapsed

  def initialize
    @board = Board.new(40, 16)
    @won = false
    @time_elapsed = 0
  end

  def play
    set_timer

    take_turn until game_over?

    reveal_bombs
    refresh_screen
    puts (won ? "you win!" : "try again!").colorize(DISPLAY_COLOR)
    check_high_score

    prompt_new_game
  end

  def take_turn
    refresh_screen

    operation, move = get_move
    until valid_move?(operation, move)
      puts "invalid move!".colorize(DISPLAY_COLOR)
      operation, move = get_move
    end

    perform_move(operation, move)
  end

  def valid_move?(operation, coordinate)
    if operation == "save" || operation == "exit"
      true
    elsif coordinate.nil?
      false
    elsif operation == "r" || operation == "f"
      (coordinate.length == 2) &&
      (coordinate.all? { |value| value.class == Fixnum &&
        value.between?(0, board.size - 1) })
    else false
    end
  end

  def perform_move(operation, move)
    case operation
    when "exit"
      quit
    when "save"
      save
    when "r"
      reveal(move) #unless flagged
    when "f"
      flag(move)
    end
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

  def prompt_new_game
    puts "play again? (y/n)".colorize(DISPLAY_COLOR)
    input = gets.chomp
    input == "y" ? Game.new_game : quit
  end

  def refresh_screen
    system("clear")
    update_timer
    puts "SWEEP THOSE MINES!".colorize(DISPLAY_COLOR)
    puts "TIMER: #{time_elapsed}".colorize(DISPLAY_COLOR)
    board.display
    puts "SAVE to save. EXIT to exit.".colorize(DISPLAY_COLOR)
  end

  def get_move
    puts "Enter r/f and coordinate (ex: \"r a,10\").".colorize(DISPLAY_COLOR)
    operation, coordinate = gets.chomp.split(" ")
    operation.downcase!

    if coordinate
      letters = ("a".."z").to_a
      coordinate = coordinate.downcase.split(",").map.with_index do |el, idx|
        idx == 0 ? letters.index(el) : el.to_i
      end.reverse
    end

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

  def check_high_score
    name, high_score = File.readlines("high_score.txt").map(&:chomp)

    if won && time_elapsed < high_score.to_i
      puts "NEW HIGH SCORE!!!!".colorize(DISPLAY_COLOR)
      update_high_score
    else display_high_score
    end
  end

  def display_high_score
    name, high_score = File.readlines("high_score.txt").map(&:chomp)

    puts "HIGH SCORE: #{name}, #{high_score}".colorize(DISPLAY_COLOR)
  end

  def update_high_score
    puts "enter name:"
    name = gets.chomp

    File.truncate('high_score.txt', 0)
    File.open('high_score.txt', "w") do |file|
      file.puts name
      file.puts time_elapsed
    end
  end

  def save
    f = File.new("SAVED_GAME.yml", "w")
    f.write(self.to_yaml)
    f.close

    puts "game saved successfully.".colorize(DISPLAY_COLOR)
    sleep(1)
  end

  def quit
    puts "bye!".colorize(DISPLAY_COLOR)
    exit
  end
end
