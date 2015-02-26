require_relative 'prime_factors_hash'
require_relative 'b_file_to_hash'
class OEIS
  def self.a070229(n)
    k = prime_factors(n).select { |_,v| v > 0 }
    n + (k.keys.max || 1)
  end
end


