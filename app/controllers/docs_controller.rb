require 'json'

class DocsController < ApplicationController
  THRIFT_FILE_PATH = 'app/'
  THRIFT_FILES = [
    'action',
    'campaign',
    'shared',
    # 'something',
  ]

  def index
    @files = []
    THRIFT_FILES.each do |f|
      @files.push(read_thrift_file(THRIFT_FILE_PATH, f))
    end
  end

  def read_thrift_file(path, filename)
    file = File.read(path + filename + '.thrift')

    # Ensure line breaks are space-separated
    file = file.gsub(/\n/, ' \n ')

    # Ensure commas are space-separated
    file = file.gsub(/,/, ' , ')

    # Split on spaces
    tokens = file.split(' ')

    @thrift_file = ThriftFile.from_token_array(filename, tokens)
  end
end
