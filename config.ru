require_relative 'app/band'
require_relative 'app/girl'
require_relative 'app/index'
require_relative 'app/lineup'
run SpiceGirls::API.new
run Bandmember::API.new
run Index.new
run Lineup::API.new
