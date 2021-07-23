class Maker
  attr_reader :code
  def initialize
    @code = gen_code
  end

  private

  def gen_code
    code = ""
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
    puts "Please make your guess"
    guess = gets.chomp
    check_guess(guess)
  end

  def check_guess(guess)
    if guess.split("").all? { |num| Array("1".."6").include?(num) } && guess.length == 4
      return guess
    else
      puts "You have to choose only from 1 to 6 for only 4 digits"
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
    judge_round
  end

  def self.call_code
    @@code
  end

  private

  def judge_round
    if @guess == @@code
      puts "end game"
    else
      give_round_result
    end
  end


end

puts Game.call_code
round1 = Game.new
