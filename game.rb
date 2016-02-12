require_relative 'board'
require_relative 'tile'
require_relative 'player'
require 'yaml'
require 'colorize'

require 'byebug'


class Game
  DISPLAY_COLOR = :green

  def self.load_game
    puts "loading saved game...".colorize(color: DISPLAY_COLOR, background: :black)
    sleep(1)

    loaded_game = YAML.load_file("SAVED_GAME.yml")
    loaded_game.play
  end

  def self.new_game
    Game.new.play
  end

  attr_reader :board, :player, :won, :score

  def initialize
    @board = Board.new(40, 16)
    @player = Player.new(@board)
    @won = false
  end

  def play
    take_turn until game_over?

    reveal_bombs
    player.display.render
    puts (won ? "you win!" : "try again!").colorize(color: DISPLAY_COLOR, background: :black)
    @score = player.display.time_elapsed

    check_high_score

    prompt_new_game
  end

  def take_turn
    pos = @player.move
    if pos == :save
      save
    elsif pos == :quit
      quit
    else
      pos.last == "f" ? flag(pos.take(2)) : reveal(pos)
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
    puts "play again? (y/n)".colorize(color: DISPLAY_COLOR, background: :black)
    input = gets.chomp
    input == "y" ? Game.new_game : quit
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

  def inspect
    "#{board.size}:#{board.num_bombs}"
  end

  def check_high_score
    name, high_score = File.readlines("high_score.txt").map(&:chomp)

    if won && score < high_score.to_i
      puts "NEW HIGH SCORE!!!!".colorize(color: DISPLAY_COLOR, background: :black)
      update_high_score
    else display_high_score
    end
  end

  def display_high_score
    name, high_score = File.readlines("high_score.txt").map(&:chomp)

    puts "HIGH SCORE: #{name}, #{high_score}".colorize(color: DISPLAY_COLOR, background: :black)
  end

  def update_high_score
    puts "enter name:"
    name = gets.chomp

    File.truncate('high_score.txt', 0)
    File.open('high_score.txt', "w") do |file|
      file.puts name
      file.puts score
    end
  end

  def save
    f = File.new("SAVED_GAME.yml", "w")
    f.write(self.to_yaml)
    f.close

    puts "game saved successfully.".colorize(color: DISPLAY_COLOR, background: :black)
    sleep(1)
  end

  def quit
    puts "bye!".colorize(color: DISPLAY_COLOR, background: :black)
    exit
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "enter NEW or LOAD."
  input = gets.chomp.downcase

  input == "load" ? Game.load_game: Game.new_game
end
