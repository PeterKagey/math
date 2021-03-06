require_relative __FILE__.sub("specs", "scripts").sub("_spec", "")

describe OEIS do

  def a(n)
    OEIS.a060878(n)
  end

  it "should know first five values" do
    expect(a(1)).to eq 129
    expect(a(2)).to eq 153
    expect(a(3)).to eq 165
    expect(a(4)).to eq 189
    expect(a(5)).to eq 195
  end

end
