# A249641: Number of strings of length n over an 8 letter alphabet that begin
# with a nontrivial palindrome.
# a(0) = 0; a(1) = 0; a(n+1) = 6*a(n) + 6^ceil(n/2) - a(ceil(n/2))
require_relative 'helpers/palindrome_counter'

class OEIS
  def self.a249641(n)
    palindrome_count(n, 8)
  end
end
