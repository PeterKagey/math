require 'open-uri'
require 'json'
require_relative 'helpers/sequence_path_iterator'
require_relative 'helpers/b_file_cache'

class BFileCompare

  PENDING_SEQUENCES ||= {
    "A000000" => "Awaiting naming and upload.",

    "A019555" => "Awaiting upload.",
    "A047932" => "Awaiting upload.",
    "A053797" => "Awaiting upload.",
    "A072905" => "Awaiting upload.",
    "A098164" => "Awaiting upload.",
    "A121341" => "Awaiting upload.",
    "A143051" => "Awaiting upload.",
    "A163325" => "Awaiting upload.",
    "A173902" => "Awaiting upload.",

    "A117484" => "Awaiting approval of Robert Israel's b-file.",

    "A258448" => "Edit (2015/09/09).",
    "A262159" => "Edit (2015/09/17).",
    "A262343" => "Edit (2015/09/18).",
    "A262351" => "Edit (2015/09/20).",

    "A143480" => "Draft (2015/09/03).",
    "A143481" => "Draft (2015/09/03).",
    "A143483" => "Draft (2015/09/03).",
    "A259439" => "Draft (2015/09/03).",
    "A261863" => "Draft (2015/09/04).",
    "A262036" => "Draft (2015/09/08).",
  }

  attr_reader :local_range, :oeis_range

  def initialize(sequence_id)
    @id = sequence_id
    @local_range = local_range
    @oeis_range = oeis_range
    update_cache
  end

  def oeis_range
    return oeis_range_from_cache if oeis_range_from_cache

    range_regex = /^%H.+\d+\.\.\d+/
    b_file_descriptor = internal_format.find { |line| line =~ range_regex }
    return "missing (OEIS)" if b_file_descriptor.nil?

    desc, min, max = b_file_descriptor.match(/n = (\d+)\.\.(\d+)/).to_a
    "#{min}..#{max}"
  end

  def local_range
    return "missing (local)" if !File.exists? b_file_path
    pairs = File.read(b_file_path).split(/\s/).each_slice(2).map(&:first)
    pairs.first + ".." + pairs.last
  end

  def skip?
    no_local_b_file?
  end

  def pending?
    !!PENDING_SEQUENCES.find { |name, _| name =~ /#{@id}/}
  end

  def pending_reason
    PENDING_SEQUENCES.find { |name, _| name =~ /#{@id}/}.last rescue "Unknown!"
  end

  private

  def b_file_path
    @b_file_path ||= BFilePathIterator.number_to_path(@id)
  end

  def cache_should_be_updated?
    return false if cache_is_more_recent_than_b_file_changes?
    @oeis_range == @local_range
  end

  def cache_is_more_recent_than_b_file_changes?
    return false if oeis_sequence_cache.nil?
    Time.parse(oeis_sequence_cache["last_updated"]) > File.mtime(b_file_path)
  end

  def update_cache
    if cache_should_be_updated?
      BFileCache.add_term(@id)
      puts "Updating cache for A#{@id}."
    elsif !skip? && @oeis_range == @local_range
      puts "Reading A#{@id} from cache."
    elsif skip?
      puts "Skipping A#{@id}."
    else
      puts "Checking OEIS for most current version of A#{@id}."
    end
  end

  def internal_format
    base = "https://oeis.org/search?q=id:A"
    format = "&fmt=text"
    open("#{base}#{@id}#{format}") { |f| f.read }.split("\n")
  end

  def oeis_cache
    return @oeis_cache if @oeis_cache
    path = File.dirname(__FILE__) + "/helpers/b_file_lookup_table.json"
    @oeis_cache = JSON.parse(File.read(path))
  end

  def oeis_sequence_cache
    oeis_cache["A#{@id}"]
  end

  def oeis_range_from_cache
    return if oeis_sequence_cache.nil?
    "#{oeis_sequence_cache["min"]}..#{oeis_sequence_cache["max"]}"
  end

  def no_local_b_file?
    !!BFilePathIterator.missing_b_files.find { |file| file =~ /#{@id}/ }
  end

end

# class OfficialBFile
# end

# class LocalBFile
# end

# class CachedBFile
# end
