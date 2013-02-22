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

  describe LocusDescription do
    before :each do
      @desc = LocusDescription.new(relative_path("test_loci.csv"))
      @first_locus, @second_locus = @desc.to_a
    end
    
    it "is an Enumerable of hashes with the keys :name, :target, :strand, " <<
       ":start, and :stop, in that order" do
      @desc.should be_kind_of(Enumerable)
      keys = [:name, :target, :strand, :start, :stop] 
      @first_locus.keys.should eq keys
      @second_locus.keys.should eq keys
    end

    describe ".new" do
      context "with one argument" do
        it "creates a set of locus specs with default column values" do
          @first_locus[:name].should eq "locus_1"
          @first_locus[:target].should eq "chr1"
          @first_locus[:strand].should eq :forward
          @first_locus[:start].should eq 1
          @first_locus[:stop].should eq 5
          @second_locus[:name].should eq "locus_2"
          @second_locus[:target].should eq "chr2"
          @second_locus[:strand].should eq :reverse
          @second_locus[:start].should eq 4
          @second_locus[:stop].should eq 8
        end
      end

      context "with an optional, second Hash argument" do
        it "uses the columns specified in the Hash instead of the defaults" do
          column_hash = { :name => 1, :target => 0 }
          other_desc = LocusDescription.new(relative_path("test_loci.csv"),
                                            column_hash)
          first_locus, second_locus = other_desc.to_a
          first_locus[:name].should eq "chr1"
          first_locus[:target].should eq "locus_1"
          second_locus[:name].should eq "chr2"
          second_locus[:target].should eq "locus_2"
        end
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

    describe "#sliced_loci" do
      it "returns an array of sequence objects sliced from the genome" do
        first_seq, second_seq = @slicer.sliced_loci
        first_seq[:name] = "locus_1"
        first_seq[:sequence] = Bio::Sequence::NA.new("accgg")
        second_seq[:name] = "locus_2"
        second_seq[:sequence] = Bio::Sequence::NA.new("ttgg")
      end
    end

    describe "#to_fasta" do
      it "returns a fasta-format string of the sliced loci" do
        @slicer.to_fasta.upcase.should eq @test_fasta.upcase
      end
    end
  end
end
