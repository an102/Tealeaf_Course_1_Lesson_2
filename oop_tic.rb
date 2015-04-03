class Board
  attr_accessor :data

  def initialize
    @data = {}
    (1..9).each { |position| data[position] = Square.new(' ') }
  end
 
  def draw
    puts '         |         |'
    puts "    #{data[1]}    |    #{data[2]}    |    #{data[3]}"
    puts '         |         |'
    puts '---------+---------+---------'
    puts '         |         |'
    puts "    #{data[4]}    |    #{data[5]}    |    #{data[6]}"
    puts '         |         |'
    puts '---------+---------+---------'
    puts '         |         |'
    puts "    #{data[7]}    |    #{data[8]}    |    #{data[9]}"
    puts '         |         |'
  end
  
  def player_positions(marker)
    data.select { |_, square| square.value == marker }.keys
  end
 
  def empty_squares
    data.select { |_, square| square.value == ' ' }.keys
  end
 
  def all_squares_occupied?
    if empty_squares.size == 0
      return true
    end
    false
  end
end

class Player
  attr_reader :name, :marker
 
  def initialize(name, marker)
    @name = name
    @marker = marker
  end
   
  def player_marks_square(player, board)
    if player.name == 'Comp'
      board.data[board.empty_squares.sample].value = player.marker
    else
      begin
        choice = gets.chomp.to_i
      end until board.empty_squares.include?(choice)
      board.data[choice].value = player.marker
    end
  end
end

class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end
 
  def to_s
    value
  end
end

class Game
  attr_reader :board, :human, :computer

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
 
  def initialize
    @board = Board.new
    @computer = Player.new('Comp', 'O')
  end
 
  def choose_name
    puts 'Welcome to Tic Tac Toe! Your name, please?'
    name = gets.chomp
    @human = Player.new(name, 'X')
  end
 
  def player_wins?(player)
    WINNING_LINES.each do |line|
      if (line & board.player_positions(player.marker)).length == 3
        return true
      end
    end
    false
  end
 
  def update_screen
    system 'clear'
    board.draw
  end
  
  def game_end_message(player)
    update_screen
    puts "#{player.name} wins!"
  end
 
  def gameplay
    system 'clear'
    choose_name
    loop do
      update_screen
      puts "\nPlease choose a position from 1 to 9 (order runs left to right, top to bottom)."
      human.player_marks_square(human, board)
      if player_wins?(human)
        game_end_message(human)
        break
      elsif board.all_squares_occupied?
        update_screen
        puts 'Draw!'
        break
      end
      computer.player_marks_square(computer, board)
      if player_wins?(computer)
        game_end_message(computer)
        break
      end
    end
  end
end

Game.new.gameplay