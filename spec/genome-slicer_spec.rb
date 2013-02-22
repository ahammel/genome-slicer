require File.expand_path('../spec_helper', __FILE__)

def relative_path(file)
  File.expand_path("../#{file}", __FILE__)
end

describe GenomeSlicer do
  before :each do
    @aatt = Bio::Sequence::NA.new("aagg")
  end

  describe Bio::Sequence::NA do
    describe "#subsequence" do
      it "returns a hash containing a string or symbol under :name and " <<
         "a Bio::Sequence::NA object sliced from the original sequence " <<
         "under :sequence" do
        sub_seq = @aatt.subsequence(:sub, 1, 2)
        sub_seq[:name].should eq :sub
        sub_seq[:sequence].should eq Bio::Sequence::NA.new("ag")
      end
    end

    describe "#reversed_subsequence" do
      it "returns a reverse-complemented #subsequence" do
        rev_seq = @aatt.reversed_subsequence(:sub, 1, 2)
        rev_seq[:sequence].should eq Bio::Sequence::NA.new("ct")
      end
    end
  end

  describe Slicer do
    before :each do
      @slicer = Slicer.new(relative_path("test.fa"), 
                           relative_path("test_loci.csv"))
      File.open(relative_path("test_loci.fa"), "r") do |io|
        @test_fasta = io.read
      end
    end

    describe "#genome" do
      it "is a hash relating the entry ids and sequences of the genome file" do
        @slicer.genome.fetch("chr1").upcase.should eq "AACCGGTT"
        @slicer.genome.fetch("chr2").upcase.should eq "TTGGCCAA"
      end
    end

    describe "#loci" do
      it "is an array of arrays of locus data" do
        first_locus, second_locus = @slicer.loci
        name, target, strand, start, stop = first_locus
        name.should eq "locus_1"
        target.should eq "chr1"
        strand.should eq "1"
        start.should eq 1
        stop.should eq 5

        name, target, strand, start, stop = second_locus
        name.should eq "locus_2"
        target.should eq "chr2"
        strand.should eq "-1"
        start.should eq 4
        stop.should eq 8
      end
    end

    describe "#to_fasta" do
      it "returns a fasta-format string of the sliced loci" do
        @slicer.to_fasta.upcase.should eq @test_fasta.upcase
      end
    end
  end
end
