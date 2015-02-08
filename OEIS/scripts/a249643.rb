# A249643: Number of strings of length n over a 10 letter alphabet that begin
# with a nontrivial palindrome.
# a(0) = 0; a(1) = 0; a(n+1) = 6*a(n) + 6^ceil(n/2) - a(ceil(n/2))
require_relative 'palindrome_counter'

class OEIS
  def self.a249643(n)
    palindrome_count(n, 10)
  end
end
