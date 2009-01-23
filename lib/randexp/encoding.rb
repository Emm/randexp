# Encoding support
# Lets one specify the encoding of /usr/share/dict/words and the encoding the results of randexp are expected in
# Defaults to ISO-8859-1/ISO-8859-1
# Change the encoding with Randexp::Encoding = 'UTF-8' or Randexp::Encoding = 'ISO-8859-1'
module Randexp::Encoding
  @@default_input_encoding = 'LATIN1'
  @@default_output_encoding = 'LATIN1'

  @@input_encoding = @@default_input_encoding
  @@output_encoding = @@default_output_encoding

  @@instances = []

  def self.included(klass)
    @@instances << klass
  end

  def self.input_encoding
    @@input_encoding
  end

  def self.input_encoding=(encoding)
    @@input_encoding = encoding
  end

  def self.output_encoding=(encoding)
    @@output_encoding = encoding
  end

  def self.output_encoding
    @@output_encoding
  end

  def self.inspect
    return "input_encoding=#{@@input_encoding}, output_encoding=#{@@output_encoding}"
  end
end

# Include or extend this module in order to be able to load data files according
# to Randexp::Encoding.input_encoding and Randexp::Encoding.output_encoding
module Randexp::EncodingAwareLoader
  @last_input_encoding = nil
  @last_output_encoding = nil

  require 'iconv'

  # Loads a file (assuming that the encoding is
  # Randexp::Encoding.input_encoding) - and converts it to
  # Randexp::Encoding.output_encoding if needed
  def load_data(file)
    if file.is_a?(String)
      contents = File.read(file)
    else # assume IO
      file.rewind # Make sure we start at the beginning - useful if we reload the dictionary
      contents = file.read
    end
    @@words = nil
    @@words_by_length = nil
    @last_input_encoding = Randexp::Encoding.input_encoding.dup
    @last_output_encoding = Randexp::Encoding.output_encoding.dup
    if Randexp::Encoding.input_encoding != Randexp::Encoding.output_encoding
      # For the love of Matz, it's really braindead to have the TARGET encoding
      # first...
      return Iconv.conv(Randexp::Encoding.output_encoding, Randexp::Encoding.input_encoding, contents)
    else
      return contents
    end
  end

  # Did we change the encoding since last time? Then we need to reload!
  def need_reload?
    @last_input_encoding != Randexp::Encoding.input_encoding || @last_output_encoding != Randexp::Encoding.output_encoding
  end

end
