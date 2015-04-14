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
        deck[card_type] = value
      end
      ['J', 'Q', 'K'].each do |letter|
        card = letter + symbol
        deck[card] = 10
      end
      deck['A' + symbol] = 11
    end
  end
end

class Participant
  attr_accessor :hand, :score
 
  def initialize
    @hand = {}
  end

  def score
    pretotal = 0
    hand.values.each { |value| pretotal += value}
    begin
      hand.keys.each do |card_type|
        if card_type[0] == 'A' && hand[card_type] == 11 && pretotal > 21
          hand[card_type] = 1
          pretotal = 0
          hand.values.each { |value| pretotal += value}
          break
        end
      end
    end while pretotal > 21 && hand.values.include?(11)
    score = pretotal
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
      #sleep (0.7)
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

  def initial_deal(cards, player, game)
    game.display
    deal(cards, player)
    game.display
    deal(cards, self)
    game.display
    deal(cards, player)
  end
 
  def final_deal(cards, game)
    begin
      deal(cards, self)
      game.display
    end until score >= 17
  end
 
  def deal(cards, participant)
    dealt_card = cards.keys.sample
    participant.hand[dealt_card] = cards.values_at(dealt_card)[0]
    cards.delete(dealt_card)
  end
end

class Game
  attr_reader :player, :dealer, :cards

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @cards = Cards.new
  end
 
  def data_to_display(participant)
    case participant
    when dealer then print "Dealer: "
    when player then print "\n#{player.name}: "
    end
    participant.hand.keys.each { |card| print "#{card} " }
    puts ''
    puts "Score: #{participant.score}"
  end
  
  def display
      system 'clear'
      data_to_display(dealer)
      data_to_display(player)
      puts ''
      sleep(0.7)
  end
 
  def end_message
    if player.bust?
      puts "#{player.name} is bust!\n\nDealer wins!"
    elsif player.blackjack? && dealer.blackjack?
      puts "Double blackjack!\n\nPush!"
    elsif player.blackjack?
      puts "Blackjack!\n\n#{player.name} wins!"
    elsif dealer.bust?
      puts "Dealer bust!\n\n#{player.name} wins!"
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
    dealer.initial_deal(cards.deck, player, self)
    player.hit_or_stay(cards.deck, dealer, self)
    dealer.final_deal(cards.deck, self) if !player.bust?
    end_message
  end
end

Game.new.gameplay