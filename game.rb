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
    


    # board

  #   board.each do |row|
  #     row.each do |tile|
  #       print #tile face value plus spacing
  #     end
  #     print '\n'
  #   end
  #
  end
end
