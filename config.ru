require 'rubygems'
require 'sinatra'

set :environment, :production
enable :sessions
disable :run, :reload

require './app'

run Sinatra::Application