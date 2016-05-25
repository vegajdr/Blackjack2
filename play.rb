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
    puts player.hand.to_s
    puts "Hit?"
    input = gets.chomp
    if input == "y"
      dealer.hit player
    end
    if dealer.hand.value < 17
      dealer.hit dealer
    end
    puts dealer.hand.to_s
    binding.pry
    puts player.hand.beats? dealer.hand
    puts
    #binding.pry
    if dealer.hand.busted? || player.hand.busted?
      puts "Round over!"
      round_over = true
    end

    # bust, round overp
  end

end