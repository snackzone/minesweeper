class Player

  def initialize(name = "Human Player")
    @name = name
  end

  def get_move
    gets.chomp
  end

end
