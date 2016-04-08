require_relative '../b_file_compare'

PENDING_SEQUENCES ||= {
  "A269526" => "Draft (04/08/2016).",
  "A096111" => "Draft (04/08/2016).",
  "A271439" => "Draft (04/08/2016).",
  "A271468" => "Draft (04/08/2016).",
  "A271471" => "Draft (04/08/2016).",
}

SequencePathIterator.sequence_numbers.each do |id|

  begin
    compare = BFileCompare.new(id)
  rescue SocketError
    puts "Could not connect to internet to check official b-file for A#{id}."
    next
  end

  next if compare.skip?

  describe "A#{id}" do
    it "should have a b-file that matches the OEIS version." do
      pending PENDING_SEQUENCES["A#{id}"] if PENDING_SEQUENCES["A#{id}"] || "#{id}" =~ /9{5}/
      expect(compare.official_range).to eq compare.local_range
    end
  end

end
