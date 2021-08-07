# frozen_string_literal: true

require 'pry-byebug'

def get_score(a, b)
  not_correct_position = []
  correct_position = []
  # find "O"
  a.each_with_index do |guess_num, guess_idx|
    idxs_of_num = b.each_index.select { |i| b[i] == guess_num }
    if idxs_of_num.include?(guess_idx)
      @round_score << 'O'
      correct_position << guess_idx
    end
  end
  # find "X"
  a.each_with_index do |guess_num, guess_idx|
    b.each_with_index do |code_num, code_idx|
      if guess_num == code_num && guess_idx == code_idx
        @round_score
      elsif guess_num == code_num && guess_idx != code_idx && !not_correct_position.include?(code_idx) && !correct_position.include?(code_idx)
        @round_score << 'X'
        not_correct_position << code_idx
        break
      end
    end
  end
  @round_score
end

puts get_score([3, 6, 5, 3], [6, 3, 3, 6])
