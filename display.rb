require "colorize"
require_relative "cursorable"

class Display
  DISPLAY_COLOR = :green

  include Cursorable

  attr_reader :board, :time_elapsed
  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    set_timer
  end

  def build_grid
    board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    end
    { background: bg}
  end

  def render
    system("clear")
    update_timer
    puts "SWEEP THOSE MINES!".colorize(DISPLAY_COLOR)
    puts "Move with arrow keys or WASD. Reveal with enter or spacebar.".colorize(DISPLAY_COLOR)
    puts "TIMER: #{time_elapsed}".colorize(DISPLAY_COLOR)
    build_grid.each { |row| puts row.join(" ") }
    puts "TAB to save. ESC to exit.".colorize(DISPLAY_COLOR)
  end

  def set_timer
    @start_time = Time.now
    @time_elapsed = 0
  end

  def update_timer
    @time_elapsed = (Time.now - @start_time).floor
  end
end
