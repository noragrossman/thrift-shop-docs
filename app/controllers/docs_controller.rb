require 'json'

class DocsController < ApplicationController
  def index
    file = File.read('app/gen-json/action.json')
    data = JSON.parse(file)

    @json = data

  end
end
