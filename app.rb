require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/partial'
require 'net/http'
require 'uri'
require 'redis'
require './config/environments' #database configuration
require './models/video_file'
require './helpers/application_helper'
require './lib/cache'

before do
  Cache.establish_connection
end

## Controller Actions
get '/' do
  "Hello, World!"
end

get '/videos' do
  @video_files = VideoFile.find(:all)
  haml :index
end

get '/videos/new' do
  haml :new
end

get '/videos/:id' do
  if @video_file = VideoFile.find(params[:id])
    haml :show
  else
    redirect '/videos'
  end
end

post '/videos' do
  params['myfile'] ? filename = "#{Digest::SHA1.hexdigest(Time.now.to_s)}_#{params['myfile'][:filename]}" : filename = ''
  @video_file = VideoFile.new(:name => params[:name], :filename => filename)
  if @video_file.save
    Cache.set("/videos/#{filename}", params['myfile'][:tempfile].read)
    File.open('uploads/' + filename, "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end
    redirect "/videos/#{@video_file.id}"
  else
    redirect '/videos'
  end
end

get '/uploads/:filename' do |filename|
  if (video = Cache.get("/videos/#{filename}")).nil?
    File.read("./uploads/#{filename}")
  else
    video
  end
end

get '/videos/:id/remove' do
  @video_file = VideoFile.find(params[:id])
  File.delete("./uploads/#{@video_file.filename}")
  @video_file.delete
  redirect '/videos'
end

get '/videos/:id/edit' do
  if @video_file = VideoFile.find(params[:id])
    haml :edit
  else
    redirect '/videos'
  end
end

put '/videos/:id' do |id|
  @video_file = VideoFile.find(params[:id])
  if @video_file.update_attribute(:name, params[:name])
    redirect "/videos/#{id}"
  else
    redirect "/videos"
  end
end