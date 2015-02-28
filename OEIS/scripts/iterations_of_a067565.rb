require_relative 'helpers/is_square'
require_relative 'a067565'

class OEIS
  def self.iterations(n)
    counter = -1
    n.is_square? ? (return counter) : n = a067565(n) while counter += 1
  end
end
