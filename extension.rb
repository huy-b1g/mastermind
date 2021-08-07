# frozen_string_literal: true

require 'pry-byebug'

def get_score(a, b)
  @round_score = []
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

puts get_score([3, 2, 6, 6], [2, 0, 2, 6])
