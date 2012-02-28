require 'rack'

rack_proc = lambda { |env| [200, {"Content-Type" => "text/plain" },
["Command line argument you typed was: #{ARGV.first}"]] }
Rack::Server.new({ app: rack_proc, server: 'webrick', Port: 3000 }).start
