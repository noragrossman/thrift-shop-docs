require 'json'

class DocsController < ApplicationController
  THRIFT_FILE_PATH = 'app/gen-json/'
  THRIFT_FILES = [
    'action.json',
    'campaign.json',
  ]

  def index
    @schemas = []
    THRIFT_FILES.each do |f|
      file = File.read(THRIFT_FILE_PATH + f)
      file_json = JSON.parse(file)
      obj = ThriftFile.from_json(file_json)
      binding.pry

      @schemas.push(obj)
    end

  end
end
