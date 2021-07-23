# frozen_string_literal: true

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

  def initialize
    @guess = get_guess
  end

  private

  def get_guess
    puts 'Please make your guess'
    guess = gets.chomp
    check_guess(guess)
  end

  def check_guess(guess)
    if guess.split('').all? { |num| Array('1'..'6').include?(num) } && guess.length == 4
      guess
    else
      puts 'You have to choose only from 1 to 6 for only 4 digits'
      get_guess
    end
  end
end

class Game
  attr_reader :guess

  @@code = Maker.new.code
  @@round = 0

  def initialize
    @@round += 1
    @guess = Breaker.new.guess
    @round_score = []
  end

  # method for debugging
  def self.call_code
    @@code
  end

  def judge_round
    if @guess == @@code
      'end game'
    else
      calc_round_result
    end
  end

  private

  def calc_round_result
    arr_guess = @guess.split('')
    arr_code = @@code.split('')
    @round_score = get_score(arr_guess, arr_code)
  end

  def get_score(a, b)
    result = []
    a.each_with_index do |num, idx|
      if num == b[idx]
        result << 'O'
        a.delete_at(idx)
        b.delete_at(idx)
        get_score(a, b)
      else
        removed_num = b.delete_at(idx)
        result << 'X' if b.include?(num)
        b.insert(idx, removed_num)
      end
    end
    result
  end
end

puts Game.call_code
round1 = Game.new
puts round1.judge_round
