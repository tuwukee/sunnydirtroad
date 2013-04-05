require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'active_record'
require 'sinatra/sprockets'

root_dir = File.dirname(__FILE__)

set :environment, :development
set :root, root_dir

disable :run

log = File.new('sinatra.log','a')
$stdout.reopen(log)
$stderr.reopen(log)

require File.expand_path '../app.rb', __FILE__
run Sinatra::Application


