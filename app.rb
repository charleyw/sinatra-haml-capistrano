require 'rubygems'
require 'json'
require 'haml'
require 'sinatra'
require "sinatra/flash"

not_found do
  haml :error
end

Dir.foreach("controllers") do |file|
  load "controllers/#{file}" unless File.directory? file
end

