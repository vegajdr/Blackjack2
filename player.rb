class Player

attr_reader :wallet, :hand

  def initialize money = 0, hand = Hand.new
    @wallet = money
    @hand = hand
  end

  def wins money
    @wallet += money
  end

  def broke?
    @wallet <= 0
  end

  def newhand
    @hand = Hand.new
  end
end
