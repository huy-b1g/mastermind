# frozen_string_literal: true

require 'pry-byebug'

class Maker
  attr_reader :code

  def initialize
    @code = gen_code
  end

  private

  def gen_code
    code = ''
    4.times { code += rand(1..6).to_s }
    code
  end
end

class Breaker
  attr_reader :guess

  def initialize(round)
    @round = round
    @guess = get_guess
  end

  private

  def get_guess
    puts "Round ##{@round}: Type in four numbers (1-6) to guess code, or 'q' to quit game."
    guess = gets.chomp
    check_guess(guess)
  end

  def check_guess(guess)
    if guess.split('').all? { |num| Array('1'..'6').include?(num) } && guess.length == 4 || guess == 'q'
      guess
    else
      puts 'You have to choose only from 1 to 6 for only 4 digits'
      get_guess
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

  # @@code = Maker.new.code

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
    case @@role
    when '2'
      is_breaker
    when '1'
      is_maker
    else
      puts "It's time to play!\nWould you like to be the code MAKER or code BREAKER?\n\nPress '1' to be the code MAKER\nPress '2' to be the code BREAKER"
      @@role = gets.chomp
      until %w[1 2].include? @@role
        puts "Enter '1' to be the code MAKER or '2' to be the code BREAKER."
        @@role = gets.chomp
      end
      if @@role == '2'
        is_breaker
      else
        is_maker
      end
    end
  end

  def is_breaker
    @guess = Breaker.new(@@round).guess
    @round_score = []
    @@code = Maker.new.code if @@round == 1
    puts 'Master-code is ' + call_code.to_s
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
      # puts 'End game. Maker won'
      quit_game
    else
      initialize
    end
  end

  def quit_game
    puts 'Game over. That was a hard code to break!'
    puts "Here is the 'master code':"
    puts @@code
    puts "Do you want to play again? Press 'y' for yes (or any other key for no)."
    replay_game
  end

  def replay_game
    select = gets.chomp
    if select == 'y'
      @@code = Maker.new.code
      @@round = 0
      @@role = ''
      initialize
    else
      puts 'Thank you for playing Mastermind!'
    end
  end
end
round1 = Game.new
