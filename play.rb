require './card'
require './deck'
require './hand'
require './player'
require './dealer'
require 'pry'


game_over = false

until game_over
  # Dealer deals
  # Player hits?
  # Result
  # Deal again
  puts "How much money do you want to bet?"
  money = gets.chomp

  dealer = Dealer.new
  player = Player.new money
  dealerplay = Player.new

  round_over = false

  dealer.deal_hand_to player
  dealer.deal_hand_to dealer
  until round_over
    puts "Player hand:"
    puts player.hand.to_s
    puts "Hit?"
    input = gets.chomp
    if input == "y"
      dealer.hit player
    else
      nil
    end
    puts player.hand.to_s
    if dealer.hand.value < 17
      dealer.hit dealer
    end
    puts "Dealer hand:"
    puts dealer.hand.to_s

    if player.hand.beats? dealer.hand
      "Player hand beats"
      round_over = true
    end
    #binding.pry
    if dealer.hand.blackjack?
      puts "Dealer hit blakjack!"
    elsif player.hand.blackjack?
      puts "Player hit blackjack"
    end

    if dealer.hand.busted?
      puts "Dealer hand busted!"
      round_over = true
    elsif player.hand.busted?
      puts "Player hand busted!"
      round_over = true
    end

  

    # bust, round overp
  end

end
