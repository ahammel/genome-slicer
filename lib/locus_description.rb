STRAND_TOKENS = {
  "1"  => :forward,
  "+"  => :forward,
  "-1" => :reverse,
  "-"  => :reverse,
}

DEFAULT_COLUMNS = {
  :name   => 0,
  :target => 1,
  :strand => 2,
  :start  => 3,
  :stop   => 4,
}


# = DESCRIPTION
# An Enumberable of Hashes containing locus information. Takes the information
# from a CSV file. The hashes have the keys :name, :target, :strand, :start and
# :stop in that order.
#
# Passing an optional hash parameter to LocusDescription.new with the keys of
# the Hash allows the user to specify which columns of the CSV the relevant
# information is stored in.
#
# The +:strand+ is always +:forward+ or +:reverse+, and is based on a lookup
# from the +STRAND_TOKENS+ hash.
#
# = USAGE
#
#   # Default behaviour: the information is stored in a CSV with
#   # the locus information in columns 0--4:
#   description = LocusDescription.new("loci.csv")
#
#   # The :name is stored in the 0th column, and the other
#   # information is in columns 5--8
#   columns = {
#     :name   => 0,
#     :target => 5,
#     :strand => 6,
#     :start  => 7,
#     :stop   => 8,
#   }
#   description = LocusDescription.new("loci.csv", columns)
#
class LocusDescription
  include Enumerable

  def initialize(filename, columns=DEFAULT_COLUMNS)
    @file = filename
    @columns = DEFAULT_COLUMNS.merge(columns)
  end

  # Processes the CSV file. Data indecies are taken from lookups of the
  # +@columns+ table.
  def loci
    CSV.read(@file).map do |row|
      {
        :name   => row[@columns[:name]],
        :target => row[@columns[:target]],
        :strand => STRAND_TOKENS[row[@columns[:strand]]],
        :start  => row[@columns[:start]].to_i - 1,  # This arithmetic gives
        :stop   => row[@columns[:stop]].to_i,       # inclusive, one-indexed
                                                    # slices
      }
    end
  end
  private :loci

  def each(&block)
    loci.each do |locus|
      if block_given?
        block.call(locus)
      else
        yield locus
      end
    end
  end
end
