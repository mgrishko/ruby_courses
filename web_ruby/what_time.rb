# encoding: utf-8
require 'sinatra'

get '/london' do
  sevastopol_time = Time.now.utc
  "In Sevastopol now: #{london_time}"
end
