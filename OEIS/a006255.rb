# http://oeis.org/A006255

# Find N
# N = 126
# 126 = 2 * 3^2 * 7
# 127 = 127
# 128 = 2^7
# 129 = 3 * 43
# 130 = 2 * 5 * 13
# ...
# 504 = 2^3 * 3^2 * 7

# represent each number as a binary string where each bit stands for the
# parity of the prime

# 1001010... would represent a number whose prime factorization was:
# 1 => 2^(odd)
# 0 => 3^(even)
# 0 => 5^(even)
# 1 => 7^(odd)
# 0 => 11^(even)
# 1 => 13^(odd)
# 1 => 17^(odd)

# For example, 2 * 7 * 13 OR 2^3 * 7 * 13^101
# Thus f(2*7*13) = 1001010...

# Now we have a list of binary strings, and we want to find the way to XOR
# combine some subset of them, using only the beginning* of the list

# in other words, we're looking for f(N) XOR f(k_1) XOR ... XOR f(k_n) such
# that f(N) XOR f(k_1) XOR ... XOR f(k_n) == 000000...
# and k_n is minimized.

##############################################################################

class BooleanMatrix
  # a boolean matrix is an array of integers where each integer is a binary 
  # representaion of a row.
  # Example: 
  #   [0 1 0 0]
  #   [0 0 0 0]
  #   [1 1 0 1]
  # would be represented by the array [0b0100, 0b0000, 0b1101] == [4, 0, 13]

  attr_accessor :column_count, :row_count, :matrix

  def initialize(matrix, opts={})
    @matrix = matrix
    @column_count = opts[:column_count]
    @column_count ||= matrix.map { |row| row.to_s(2).length }.max
    @row_count = opts[:row_count] || matrix.length
  end

  def self.construct(n, primes = false)
    primes ||= Primes.sieve(2*n)
    upper_bound = (n > 3) ? (2 * n) : (4 * n)
    x = (n+1..upper_bound).collect { |i| f(i, primes) } << f(n, primes)
    BooleanMatrix.new(x).transpose
  end

  def _i_j_entry(i, j)
    shift = @column_count - j - 1
    matrix[i] >> shift & 1
  end

  def _read_column(j)
    column_sum = 0
    (0...@row_count).each do |i|
      column_sum <<= 1
      column_sum += _i_j_entry(i, j)
    end
    column_sum
  end

  def transpose
    x = (0...@column_count).collect do |column_index|
      _read_column(column_index)
    end
    BooleanMatrix.new(x, {column_count: row_count, row_count: @column_count})
  end

  def print
    matrix.each do |row|
      puts row.to_s(2).rjust(@column_count, '0').split('').join(' ')
    end
  end

  def _done_reducing?(curr_col, comp_rows)
    curr_col >= column_count || comp_rows >= row_count
  end

  def _swap_rows(r_1, r_2)
    matrix[r_1], matrix[r_2] = matrix[r_2], matrix[r_1]
  end

  def _swap_to_the_top(column_index, top_row_index)
    (top_row_index...@row_count).each do |row_index|
      if _i_j_entry(row_index, column_index) == 1
        _swap_rows(row_index, top_row_index)
        return true
      end
    end
    false
  end

  def _clear_column(column_index, top_row_index)
    (0...@row_count).each do |row_index|
      next if row_index == top_row_index
      if _i_j_entry(row_index, column_index) == 1
        matrix[row_index] ^= matrix[top_row_index]
      end
    end
    self
  end

  def _rref
    r_i, c_i = 0, 0
    (0...column_count).each do |c_i|
    break if _done_reducing?(c_i, r_i)
      if _swap_to_the_top(c_i, r_i)
        _clear_column(c_i, r_i)
        r_i += 1
      end 
    end
    self
  end

  def _bytes(integer)
    # given some integer _bytes(integer) returns the positions of non-zero indices
    # e.g. _bytes(0b10010) = [1,4] 
    base_two_digits = integer.to_s(2).length
    (0...base_two_digits).select do |bit_position|
      integer & (1 << bit_position) != 0
    end
  end

  def interpret
    m = _rref.transpose.matrix
    terms = [-1] +
    _bytes(m.last).reverse.collect do |i|
      m.index(1 << i)
    end
    terms.map { |x| x + @column_count }
  end
end

class Primes

  attr_reader :list

  def initialize(upper_bound)
    @list = _sieve(upper_bound)
  end

  def _sieve(n)
    threshold = Math.sqrt(n).to_i
    bool_arry = [false, false] + [true] * (n-1)
    
    prime = 2
    loop do
      (prime**2..n).step(prime).each { |i| bool_arry[i] = false }
      (prime+1..threshold).each { |k| prime = k; break if bool_arry[prime] }
      break if prime >= threshold
    end
    bool_arry.each_index.select{ |i| bool_arry[i] }
  end

  def f(n)
    h = factors(n).sort
    m = 0
    h.reverse.each { |x| m <<= 1; m += x[1] % 2 }
    m
  end

  def factors(n) # factors(12) = { 2=>2, 3=>1 }
    factors_hash = {}
    list.each do |q|
      factors_hash[q] = 0
      (n /= q; factors_hash[q] += 1) while n % q == 0
      break if n == 1
    end
    factors_hash
  end

  def product_ary_is_square?(ary)
    return true if ary == []
    factors_hash = Hash.new(0)
    ary.each do |n|
      factors(n).each { |k,v| factors_hash[k] += v }
    end
    factors_hash.each { |k,v| return false if v % 2 == 1 }
    true
  end

end

primes = Primes.new(10**5)
(1..200).each { |x| puts '%5s' % "#{x} " + primes.f(x).to_s }
