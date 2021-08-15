# frozen_string_literal: true

module UserInput
  def get_input(role, round)
    if role == '2'
      puts "Round ##{round}: Type in four numbers (1-6) to guess code, or 'q' to quit game."
    elsif role == '1'
      puts "Type in four numbers (1-6) to set maste-code, or 'q' to quit game."
    end
    input = gets.chomp
    check_input(input, role, round)
  end

  def check_input(input, role, round)
    if input.split('').all? { |num| Array('1'..'6').include?(num) } && input.length == 4 || input == 'q'
      input
    else
      puts 'You have to choose only from 1 to 6 for only 4 digits'
      get_input(role, round)
    end
  end
end

class Maker
  attr_reader :code

  include UserInput
  def initialize(round, role)
    @code = gen_code if role == '2'
    @code = get_input(role, round) if role == '1'
  end

  private

  def gen_code
    code = ''
    4.times { code += rand(1..6).to_s }
    code
  end
end

class Breaker
  include UserInput
  attr_reader :guess

  def initialize(round, role)
    @round = round
    @guess = get_input(role, round) if role == '2' # user are breaker
    if role == '1' # user are maker
      computer_code = []
      4.times { computer_code << rand(1..6) }
      @guess = computer_code.join('')
    end
  end
end

class Game
  # attr_reader :guess
  @@round = 0
  @@role = ''

  def initialize
    @@round += 1
    maker_or_breaker
  end
  
  private

  # method for debugging
  def call_code
    @@code
  end

  def judge_round
    if @guess == @@code
      @round_score = %w[O O O O]
      show_round_score
      puts 'End game. Breaker won.'
      puts "Do you want to play again? Press 'y' for yes (or any other key for no)."
      replay_game
    elsif @guess == 'q'
      quit_game
    else
      calc_round_result
    end
  end

  def maker_or_breaker
    if @@role == '1' || @@role == '2'
      create_code
    else
      puts "It's time to play!\nWould you like to be the code MAKER or code BREAKER?\n\nPress '1' to be the code MAKER\nPress '2' to be the code BREAKER"
      @@role = gets.chomp
      until %w[1 2].include? @@role
        puts "Enter '1' to be the code MAKER or '2' to be the code BREAKER."
        @@role = gets.chomp
      end
      create_code if @@role == '2' || @@role == '1'
    end
  end

  def create_code
    @@code = Maker.new(@@round, @@role).code if @@round == 1
    @guess = Breaker.new(@@round, @@role).guess
    @round_score = []
    #puts 'Master-code is ' + call_code.to_s
    puts "Computer's guess: " + @guess if @@role == '1'
    judge_round
  end

  def calc_round_result
    arr_guess = @guess.split('')
    arr_code = @@code.split('')
    get_score(arr_guess, arr_code)
    show_round_score
    to_next_turn
  end

  def get_score(a, b)
    not_correct_position = []
    correct_position = []
    # find "O"
    a.each_with_index do |num, idx|
      if num == b[idx]
        @round_score << 'O'
        correct_position << idx
      end
    end

    # find "X"
    a.each_with_index do |guess_num, guess_idx|
      b.each_with_index do |code_num, code_idx|
        unless guess_num == code_num && guess_idx != code_idx && !not_correct_position.include?(code_idx) && !correct_position.include?(code_idx) && !correct_position.include?(guess_idx)
          next
        end

        @round_score << 'X'
        not_correct_position << code_idx
        break
      end
    end
    @round_score
  end

  def show_round_score
    print 'Clues: '
    display = ''
    @round_score.each { |num| display += "#{num} " if num == 'O' }
    @round_score.each { |num| display += "#{num} " if num == 'X' }
    puts display
  end

  def to_next_turn
    if @@round == 12
      quit_game
    else
      initialize
    end
  end

  def quit_game
    puts 'Game over. Maker won!'
    puts "Here is the 'master code':"
    puts @@code
    puts "Do you want to play again? Press 'y' for yes (or any other key for no)."
    replay_game
  end

  def replay_game
    select = gets.chomp
    if select == 'y'
      @@round = 0
      @@role = ''
      initialize
    else
      puts 'Thank you for playing Mastermind!'
    end
  end
end
round1 = Game.new
