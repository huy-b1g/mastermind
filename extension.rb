# frozen_string_literal: true
require 'pry-byebug'
result = []
def get_score(a, b, result)
  a.each_with_index do |num, idx|
    if num == b[idx]
      result << 'O'
      a.delete_at(idx)
      b.delete_at(idx)
      get_score(a, b, result)
    else
      removed_num = b.delete_at(idx)
      result << 'X' if b.include?(num)
      b.insert(idx, removed_num)
#  binding.pry
    end
    break if result.length == 4
  end
  result
end

puts get_score([5,4,1,6], [5,4,6,1], result)
