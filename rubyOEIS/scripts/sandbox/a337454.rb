# ???????????????????
def a336597(n)
  num = (0...n)    # .select { |k| n % k == 0 }
    .map { |k|
      [
        # k,
        # (0...n).count { |m| (m**k - m) % n == 0 }/(0...n).count { |m| (-m**k - m) % n == 0 },
        (0...n).count { |m| (m**k - m) % n == 0 },
        (0...n).count { |m| (-m**k - m) % n == 0 }
      ]
    }
  num
end

p 1,a336597(1)
p 2,a336597(2)
p 3,a336597(3)
p 4,a336597(4)
p 5,a336597(5)
p 6,a336597(6)

p 7,a336597(7)
p 8,a336597(8)
