# frozen_string_literal: true

require 'pry-byebug'
result = []
def get_score(a, b, result)
  correct_position = []
  a.each_with_index do |num, idx|
    if num == b[idx]
      result << 'O'
      correct_position << idx
    end
  end
  rmd_correct_guess_arr = a.reject.with_index { |_e, i| correct_position.include? i }
  rmd_correct_code_arr = b.reject.with_index { |_e, i| correct_position.include? i }

  rmd_correct_guess_arr.each_with_index do |num, idx|
    removed_num = rmd_correct_code_arr.delete_at(idx)
    result << 'X' if rmd_correct_code_arr.include?(num)
    rmd_correct_code_arr.insert(idx, removed_num)
  end
  result
end
a = [6, 4, 5, 4]
b = [6, 4, 4, 6]
 def test
    input = gets.chomp
    until ["1","2"].include? input
      input = gets.chomp
    end
    puts input
 end

test
