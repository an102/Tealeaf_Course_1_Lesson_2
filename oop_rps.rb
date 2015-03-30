class Hand
  attr_reader :choice
 
  include Comparable
 
  def initialize(choice)
    @choice = choice
  end
 
  def <=>(other)
    if choice == other.choice
      0
    elsif choice == "rock" && other.choice == "scissors" ||
      choice == "paper" && other.choice == "rock" ||
      choice == "scissors" && other.choice == "paper"
      1
    else
      -1
    end
  end
end

class Player
  attr_accessor :name, :hand
end

class Human < Player
  def set_name
    self.name = gets.chomp
  end
 
  def choose_hand
    begin
      puts "Choose your weapon! (r/p/s)"
      choice = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(choice)
  
    self.hand = Hand.new(Game::CHOICES.values_at(choice)[0])
  end
end

class Computer < Player
  def initialize
    self.name = "Computer"
  end
 
  def choose_hand
    self.hand = Hand.new(Game::CHOICES.values.sample)
  end
end

class Game
  attr_reader :human, :computer

  CHOICES = {"r" => "rock", "p" => "paper", "s" => "scissors"}

  def initialize
    @human = Human.new
    @computer = Computer.new
  end
 
  def compare_hands
    if human.hand > computer.hand
      winning_message(human.hand.choice)
      puts "#{human.name} wins!"
    elsif computer.hand > human.hand
      winning_message(computer.hand.choice)
      puts "#{computer.name} wins!"
    else
      puts "Draw!"
    end
  end
 
  def winning_message(winning_hand)
    case winning_hand
    when "rock" then puts "Rock smashes scissors!"
    when "paper" then puts "Paper covers rock!"
    when "scissors" then puts "Scissors cuts paper!"
    end
  end
 
  def gameplay
    puts "Welcome to Rock, Paper, Scissors! Your name, please?"
    human.set_name
    loop do
      human.choose_hand
      computer.choose_hand
      puts "\n#{human.name} => #{human.hand.choice}"
      puts "#{computer.name} => #{computer.hand.choice}\n "
      compare_hands
      begin
        puts "\nGo again? (y/n)"
        response = gets.chomp.downcase
      end until ["y", "n"].include?(response)
      if response == "y"
        puts ""
      else
        puts "\nGoodbye!"
        break
      end
    end
  end
end

Game.new.gameplay