require 'sinatra/base'
#this is for the web page to call all the functions
#not yet built

class Index < Sinatra::Base
  get '/' do
    "hello world!"
  end
end
