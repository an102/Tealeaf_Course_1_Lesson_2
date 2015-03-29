class Hand
  attr_reader :choice
  
  include Comparable
  
  def initialize(choice)
    @choice = choice
  end
  
  def <=>(other)
    if @choice == other.choice
      0
    elsif @choice == "rock" && other.choice == "scissors" ||
      @choice == "paper" && other.choice == "rock" ||
      @choice == "scissors" && other.choice == "paper"
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
  def initialize
    self.name = gets.chomp
  end
  
  def choose
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
    self.hand = Hand.new(Game::CHOICES.values.sample)
  end
end

class Game
  attr_reader :human, :computer

  CHOICES = {"r" => "rock", "p" => "paper", "s" => "scissors"}

  def initialize
    puts "Welcome to Rock, Paper, Scissors! Your name, please?"
    @human = Human.new
    gameplay
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
    when "rock"
      puts "Rock smashes scissors!"
    when "paper"
      puts "Paper covers rock!"
    when "scissors"
      puts "Scissors cuts paper!"
    end
  end
 
  def gameplay
    human.choose
    @computer = Computer.new
    
    puts "\n#{human.name} => #{human.hand.choice}"
    puts "#{computer.name} => #{computer.hand.choice}\n "
    
    compare_hands
    
    begin
      puts "\nGo again? (y/n)"
      response = gets.chomp.downcase
    end until ["y", "n"].include?(response)
    if response == "y"
      puts ""
      gameplay
    else
      puts "\nGoodbye!"
    end
  end
end

Game.new