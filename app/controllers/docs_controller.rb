require 'json'

class DocsController < ApplicationController
  THRIFT_FILE_PATH = 'app/gen-json/'
  THRIFT_FILES = [
    'action.json',
    'campaign.json',
  ]

  def index
    # @schemas = []
    # THRIFT_FILES.each do |f|
    #   file = File.read(THRIFT_FILE_PATH + f)
    #   file_json = JSON.parse(file)
    #   obj = ThriftFile.from_json(file_json)
    #   @schemas.push(obj)
    # end

    file = File.read('app/something.thrift')
    # Ensure line breaks are space-separated
    file = file.gsub(/\n/, ' \n ')

    # Ensure commas are space-separated
    file = file.gsub(/,/, ' , ')

    # Split on spaces
    tokens = file.split(' ')

    @thrift_file = ThriftFile.from_token_array(tokens)
  end
end
