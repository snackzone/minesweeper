require_relative 'board'

class Tile

  attr_reader :bomb, :revealed, :flagged
  attr_accessor :neighbors

  def initialize(bomb)
    @bomb = bomb == "bomb" ? true : false
    @revealed = false
    @flagged = false
    @neighbors = []
  end



end
