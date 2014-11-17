# If we list all the natural numbers below 10 that are multiples of 3 or 5, 
# we get 3, 5, 6 and 9. The sum of these multiples is 23.
# Find the sum of all the multiples of 3 or 5 below 1000.

start = Time.now
p (1...1000).select{ |n| n % 3 == 0 || n % 5 == 0 }.reduce(:+)
p Time.now - start

# 0.000449 seconds to run