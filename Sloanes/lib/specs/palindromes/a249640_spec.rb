require_relative '../../scripts/palindromes/a249640'

describe OEIS do

  def a(n)
    OEIS.a249640(n)
  end

  it "should know first five values" do
    expect(a(0)).to eq 0
    expect(a(1)).to eq 0
    expect(a(2)).to eq 7
    expect(a(3)).to eq 91
    expect(a(4)).to eq 679
  end

end