$:.unshift File.expand_path('../lib', __FILE__)

require 'bundler/setup'

require 'pry'
require 'rspec'
require 'rspec/expectations'
require 'webmock/rspec'

require 'service_utilities'

def require_dir(path_from_root)
  Dir[File.expand_path("../../#{path_from_root}/**/*.rb", __FILE__)].sort.each do |f|
    require f
  end
end

require_dir 'spec/support'

RSpec.configure do |config|
end
