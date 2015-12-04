require_relative 'board'

class Tile

  attr_reader :flagged
  attr_accessor :neighbors, :revealed, :bomb

  def initialize(board)
    @bomb = false
    @revealed = false
    @flagged = false
    @neighbors = []
    @display_value = "*"
    @board = board
  end

  def reveal
    revealed = true
  end

  def display
    # unless revealed
    #   @display_value
    # end
  end

end
