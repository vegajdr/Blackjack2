class Dealer

attr_reader :deck, :hand

  def initialize
    @deck = Deck.new
    @hand = Hand.new

  end

  def deal_hand_to player
      player.newhand
      player.hand.cards.push(@deck.draw)
      player.hand.cards.push(@deck.draw)
    #binding.pry

  end

  def hit player
    if @deck.cards.count == 0
      @deck.reshuffle
    end
    player.hand.cards.push(@deck.draw)

  end

  def newhand
    @hand = Hand.new
  end

end
