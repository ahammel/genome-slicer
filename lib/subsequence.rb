#
# = subsequence.rb - monkeypatch on Bio::Sequence::NA
#

require 'bio'

# = DESCRIPTION
#   A monkeypatch on Bio::Sequence::NA adding the #subsequence method,
#   documented below.
#
class Bio::Sequence::NA

  # Returns a hash associating a sequence name with a Bio::Sequence::NA object
  # taken from a subsequence sliced from self.
  #
  # Examples:
  #
  #   seq = Bio::Sequence::NA.new("acgt")
  #   subseq = seq.subsequence(:subsequence, 1, 2)
  #   puts subseq[:name]                        # => subsequence
  #   puts subseq[:sequence]                    # => "cg"
  #
  # ---
  # *Arguments*:
  # * (required) _name_:  Symbol or String
  # * (required) _start_: Integer
  # * (required) _stop_:  Integer
  # *Returns*::Hash object
  def subsequence(name, start, stop)
    { 
      :name => name, 
      :sequence => self[start..stop], 
    }
  end

  # As #subsequence, but with the +:sequence+ reverse-complemented
  #
  # Examples:
  #
  #   seq = Bio::Sequence::NA.new("aaaa")
  #   subseq = seq.subsequence(:subsequence, 1, 2)
  #   puts subseq[:name]                        # => subsequence
  #   puts subseq[:sequence]                    # => "tt"
  #
  # ---
  # *Arguments*:
  # * (required) _name_:  Symbol or String
  # * (required) _start_: Integer
  # * (required) _stop_:  Integer
  # *Returns*::Hash object
  def reversed_subsequence(*args)
    sub_seq = subsequence(*args)
    sub_seq[:sequence].reverse_complement!
    sub_seq
  end
end
