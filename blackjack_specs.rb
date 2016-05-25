require 'minitest/autorun'
require 'minitest/focus'
require 'pry'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require './card'
require './deck'
require './hand'
require './player'
require './dealer'

class TestCard < Minitest::Test

  def test_number_card_value
    2.upto(10) do |x|
      card = Card.new(x, :S)
      assert_equal card.value, x
    end
  end

  def test_face_card_value
    [:K, :Q, :J].each do |rank|
      card = Card.new(rank, :H)
      assert_equal card.value, 10
    end
  end
end

class TestDeck < Minitest::Test
  def test_counting_cards
    deck = Deck.new
    assert_equal deck.cards.count, 52
  end

  def test_counting_draws
    deck = Deck.new
    deck.draw
    assert_equal deck.cards.count, 51
  end

  def test_tracking_draws
    deck = Deck.new
    drawn_card = deck.draw
    assert_equal deck.cards.count, 51
    refute_includes deck.cards, drawn_card
    assert_includes deck.drawn, drawn_card
  end

  def test_reshuffling
    deck = Deck.new
    5.times { deck.draw }
    deck.reshuffle

    assert_equal 52, deck.cards.count
    assert_equal [], deck.drawn
  end

end

class TestHand < Minitest::Test
  def test_hand_value_with_number_cards
    hand = Hand.new
    hand.add(Card.new(9, :H), Card.new(7, :S))
    assert_equal hand.value, 16

    hand.add(Card.new(4, :D))
    assert_equal hand.value, 20
  end

  def test_hand_value_with_face_cards
    hand = Hand.new
    hand.add(Card.new(9, :H), Card.new(:K, :S))
    assert_equal hand.value, 19
  end

  def test_hand_value_with_aces
    hand = Hand.new
    hand.add(Card.new(:A, :H), Card.new(:K, :S))
    assert_equal hand.value, 21

    hand.add(Card.new(5, :S))
    assert_equal hand.value, 16
  end

  def test_busting
    hand = Hand.new
    hand.add(Card.new(6, :H), Card.new(:K, :S), Card.new(9, :H))
    assert hand.busted?
  end

  def test_blackjack
    hand = Hand.new
    hand.add(Card.new(:A, :H), Card.new(:K, :S))
    assert hand.blackjack?
  end

  def test_hand_as_string
    hand = Hand.new
    hand.add(Card.new(:A, :H), Card.new(:K, :S))
    hand.add(Card.new(5, :S))
    assert_equal hand.to_s, 'AH, KS, 5S'
  end

  def test_showing_as_string
    hand = Hand.new
    hand.add(Card.new(:A, :H), Card.new(:K, :S))
    hand.add(Card.new(5, :S))
    assert_equal hand.showing, 'AH'
  end

  def test_blackjack_beats_other_things
    h1 = Hand.new
    h1.add(Card.new(:A, :H), Card.new(:K, :S))

    h2 = Hand.new
    h2.add(Card.new(5, :S), Card.new(:Q, :S))

    assert h1.beats?(h2)
    refute h2.beats?(h1)
  end

  def test_busted_hands_dont_beat_unbusted_hands
    h1 = Hand.new
    h1.add(Card.new(3, :H), Card.new(6, :S))

    h2 = Hand.new
    h2.add(Card.new(:K, :H), Card.new(5, :S), Card.new(:Q, :S))

    assert h1.beats?(h2)
    refute h2.beats?(h1)
  end

  def test_hands_can_tie
    h1 = Hand.new
    h1.add(Card.new(4, :H), Card.new(6, :S))

    h2 = Hand.new
    h2.add(Card.new(5, :H), Card.new(5, :D))

    refute h1.beats?(h2)
    refute h2.beats?(h1)
  end
end

class PlayerTest < Minitest::Test
  def test_players_have_wallets
    p = Player.new 100
    assert_equal 100, p.wallet
  end

  def test_players_can_win_money
    p = Player.new 50
    p.wins 10
    assert_equal 60, p.wallet
  end

  def test_players_have_a_hand
    p = Player.new
    assert p.hand.is_a?(Hand)
  end

  def test_players_can_be_broke
    p = Player.new 10
    refute p.broke?

    p.wins -10
    assert p.broke?
  end
end

class DealerTest < Minitest::Test
  def test_can_deal_a_hand
    p = Player.new
    d = Dealer.new

    d.deal_hand_to p
    assert_equal 2, p.hand.cards.count
  end

  def test_can_deal_a_card
    p = Player.new
    d = Dealer.new

    d.deal_hand_to p
    d.hit p
    assert_equal 3, p.hand.cards.count
  end

  def test_dealing_a_new_hand_resets
    p = Player.new
    d = Dealer.new

    d.deal_hand_to p
    d.hit p

    d.deal_hand_to p
    assert_equal 2, p.hand.cards.count
  end

  def test_dealer_holds_the_deck
    d = Dealer.new
    assert d.deck.is_a?(Deck)
    assert_equal [], d.deck.drawn
  end

  def test_dealer_deals_from_the_deck
    d = Dealer.new
    p = Player.new

    d.deal_hand_to p
    assert_equal 2, d.deck.drawn.count
  end

  def test_dealer_reshuffles_the_deck_when_needed
    d = Dealer.new
    p = Player.new

    d.deal_hand_to p
    50.times { d.hit p }
    assert_equal  0, d.deck.cards.count

    # This should re-start the deck / grab
    #   a new one
    # Don't worry about the player already
    #   "holding" these cards
    d.hit p
    assert_equal  51, d.deck.cards.count
  end
end
