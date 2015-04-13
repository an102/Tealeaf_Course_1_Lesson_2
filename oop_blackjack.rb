#oop_blackjack.rb

class Cards
  attr_accessor :deck
 
  def initialize
    @deck = {}
    create_deck
  end
 
  def create_deck
    ['♠', '♥', '♦', '♣'].each do |symbol|
      (2..10).each do |value|
        card_type = value.to_s + symbol
        self.deck[card_type] = value
      end
      ['J', 'Q', 'K'].each do |letter|
        card = letter + symbol
        self.deck[card] = 10
      end
      self.deck['A' + symbol] = 11
    end
  end
end

class Participant
  attr_accessor :hand, :score, :ace_counter
 
  def initialize
    @hand = {}
    @ace_counter = 0
  end

  def score
    pretotal = 0
    total = 0
    
    hand.values.each { |value| pretotal += value}
    if (ace_counter > 1) || (ace_counter == 1 && pretotal > 21)
      hand.keys.each { |card_type| hand[card_type] = 1 if card_type[0] == 'A' }
      hand.values.each { |value| total += value}
      self.score = total
    else
       hand.values.each { |value| total += value}
      self.score = total
    end
  end
 
  def bust?
    score > 21
  end
 
  def blackjack?
    score == 21 && hand.keys.size == 2
  end
end
 
class Player < Participant
  attr_accessor :name

  def choose_name
    system 'clear'
    puts "Welcome to Blackjack!\n\nYour name, please?"
    begin
      n = gets.chomp.capitalize
    end while n.empty?
    self.name = n
  end
 
  def non_blackjack_21?
    score == 21 && hand.keys.size > 2
  end
  
  def hit_or_stay(cards, dealer, game)
    loop do
      game.display
      break if bust? || blackjack? || non_blackjack_21? || dealer.blackjack?
      sleep (0.7)
      puts "Hit or stay? (h/s)"
      begin
        choice = gets.chomp.downcase
      end until ['hit', 'stay', 'h', 's'].include?(choice)
      if ['hit', 'h'].include?(choice)
        dealer.deal(cards, self)
      else
        break
      end
    end
  end
end

class Dealer < Participant

  def initial_deal(cards, player)
    deal(cards, player)
    deal(cards, self)
    deal(cards, player)
  end
 
  def final_deal(cards, game)
    begin
      deal(cards, self)
    end until score >= 17
    game.display
  end
  
  def deal(cards, participant)
    dealt_card = cards.keys.sample
    participant.hand[dealt_card] = cards.values_at(dealt_card)[0]
    cards.delete(dealt_card)
    participant.ace_counter += 1 if dealt_card[0] == 'A'
  end
end

class Game
  attr_reader :player, :dealer, :cards
  
  @@dealer_cards_to_display = []
  @@player_cards_to_display = []

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @cards = Cards.new
  end
 
  def display
    dealer_score_cycle_check = 0
    player_score_cycle_check = 0
    
    loop do
      system 'clear'
      print "Dealer: "
      dealer_card_type = dealer.hand.keys[@@dealer_cards_to_display.size]
      @@dealer_cards_to_display.each { |card| print "#{card} " }
      puts ''
      if @@dealer_cards_to_display.size == dealer.hand.keys.size
        puts "Score: #{dealer.score}"
        dealer_score_cycle_check = 1
      else
        temp_score = 0
        @@dealer_cards_to_display.each { |card| temp_score += dealer.hand.values_at(card)[0] }
        @@dealer_cards_to_display.push(dealer_card_type)
        puts "Score: #{temp_score}"
      end
      print "\n#{player.name}: "
      player_card_type = player.hand.keys[@@player_cards_to_display.size]
      @@player_cards_to_display.each { |card| print "#{card} " }
      puts ''
      if @@player_cards_to_display.size == player.hand.keys.size
        puts "Score: #{player.score}\n "
        player_score_cycle_check = 1
      else
        temp_score = 0
        @@player_cards_to_display.each { |card| temp_score += player.hand.values_at(card)[0] }
        @@player_cards_to_display.push(player_card_type)
        puts "Score: #{temp_score}"
      end
      break if (dealer_score_cycle_check + player_score_cycle_check) == 2
      sleep(0.7)
    end
  end
  
  def end_message
    if player.bust?
      puts "#{player.name} is bust!\n\nDealer wins!"
    elsif dealer.bust?
      puts "Dealer bust!\n\n#{player.name} wins!"
    elsif player.blackjack? && dealer.blackjack?
      puts "Double blackjack!\n\nPush!"
    elsif player.blackjack?
      puts "Blackjack!\n\n#{player.name} wins!"
    elsif dealer.blackjack?
      puts "Dealer blackjack!\n\nDealer wins!"
    elsif dealer.score == player.score
      puts 'Push!'
    elsif dealer.score > player.score
      puts "Dealer wins!"
    else
      puts "#{player.name} wins!"
    end
  end
  
  def gameplay
    player.choose_name
    dealer.initial_deal(cards.deck, player)
    player.hit_or_stay(cards.deck, dealer, self)
    dealer.final_deal(cards.deck, self) if !player.bust? && !player.blackjack?
    sleep(0.7)
    end_message
  end
end

Game.new.gameplay