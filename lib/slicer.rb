require File.expand_path('../subsequence', __FILE__)
require 'csv'

POSITIVE_STRAND_TOKENS = ["1", "+"]
NEGATIVE_STRAND_TOKENS = ["-1", "-"]


# = DESCRIPTION
# A Slicer object combines a Bio::FlatFile with a set of specifications of
# loci. The #sliced_loci method returns an array of Bio::Sequence::NA objects
# 'sliced out' of the genome according to the locus specifications.
#
#  = USAGE
#    #Create a new slicer object
#    slicer = Slicer.new("genome.fa", "loci.csv")
#
#    #Do something with the sliced loci
#    slicer.sliced_loci.each do |locus|
#      # do something
#    end
#
#    #Print the sliced loci to a FASTA file
#    puts slicer.to_fasta
#
class Slicer
  attr_reader :genome, :loci

  def initialize(genome_file, loci_file)
    sequences = Bio::FlatFile.auto(genome_file)
    @genome = Hash[ sequences.map { |entry| [entry.entry_id, entry.naseq] } ]
    @loci = CSV.read(loci_file).map do |name, target, strand, start, stop|
      [
        name,
        target,
        strand,
        start.to_i - 1, # This arithmetic gives inclusive, 
        stop.to_i,      # one-indexed slices
      ]
    end
  end

  # Returns an array of loci extracted from the +@genome+
  def sliced_loci
    @loci.map do |slice|
      name, target, strand, start, stop = slice
      target_sequence = @genome.fetch(target)
      if POSITIVE_STRAND_TOKENS.include?(strand) 
        target_sequence.subsequence(name, start, stop)
      elsif NEGATIVE_STRAND_TOKENS.include?(strand )
        target_sequence.reversed_subsequence(name, start, stop)
      end
    end
  end

  # Returns a FASTA-format string of the +sliced_loci+. Headers are
  # +Bio::Sequence::NA#entry_id+s, sequences should speak for themselves.
  def to_fasta
    sliced_loci.inject(String.new) do |fasta_string, locus|
      name = locus[:name]
      sequence = locus[:sequence]
      fasta_string << sequence.to_fasta(name, 60)
    end
  end
end
