class Tile

  def initialize(bomb)
    @bomb = bomb == "bomb" ? true : false
    @revealed = false
    @flagged = false
  end

  def inspect
    @bomb
  end


end
