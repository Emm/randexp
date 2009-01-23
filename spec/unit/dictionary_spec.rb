require File.dirname(__FILE__) + '/../spec_helper'

describe Randexp::Dictionary do

  it "should load the dictionary file" do
    dummy_dict_io = StringIO.new(%w{meow woof moooh}.join("\n"))
    Randexp::Dictionary.load_dictionary(dummy_dict_io)
    dummy_dict_io.close
    Randexp::Dictionary.words.length.should == 3
    Randexp::Dictionary.words.include?("meow").should be_true
    Randexp::Dictionary.words.include?("woof").should be_true
    Randexp::Dictionary.words.include?("moooh").should be_true
  end

  it "should have the encoding specified in Randex::Encoding" do
    # stupid dictionary containing one e acute in latin1
    dummy_dict_io = StringIO.new("\xe9")
    Randexp::Dictionary.default_dictionaries << dummy_dict_io
    Randexp::Encoding.output_encoding = "UTF-8"
    Randexp::Dictionary.load_dictionary
    Randexp::Dictionary.words.length.should == 1
    # This is the UTF-8 version
    Randexp::Dictionary.words.include?("\xc3\xa9").should be_true
    Randexp::Encoding.output_encoding = "LATIN1"
    Randexp::Dictionary.words.include?("\xe9").should be_true
    dummy_dict_io.close
  end
end
