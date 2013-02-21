
require File.expand_path('../spec_helper', __FILE__)

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
end
