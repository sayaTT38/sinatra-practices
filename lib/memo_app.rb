# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

MEMOS_FILE = File.join(__dir__, 'memos.json')
LAST_ID_FILE = File.join(__dir__, 'last_id.json')

def read_memos
  if File.exist?(MEMOS_FILE)
    JSON.parse(File.read(MEMOS_FILE))
  else
    data = {}
    write_json(MEMOS_FILE, data)
    data
  end
end

def read_last_id
  if File.exist?(LAST_ID_FILE)
    JSON.parse(File.read(LAST_ID_FILE))
  else
    write_json(LAST_ID_FILE, 0)
    0
  end
end

def write_json(file, data)
  File.write(file, JSON.generate(data))
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos
  erb :top
end

post '/memos' do
  memos = read_memos
  last_id = read_last_id
  next_id = last_id + 1
  last_id = next_id
  memos[next_id.to_s] = { 'id' => next_id, 'title' => params['title'], 'content' => params['content'] }
  write_json(LAST_ID_FILE, last_id)
  write_json(MEMOS_FILE, memos)
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = read_memos
  @memo = memos[params['id']]
  erb :show
end

delete '/memos/:id' do
  memos = read_memos
  memos.delete(params['id'])
  write_json(MEMOS_FILE, memos)
  redirect '/memos'
end

patch '/memos/:id' do
  memos = read_memos
  memo = memos[params['id']]
  memo['title'] = params['title']
  memo['content'] = params['content']
  write_json(MEMOS_FILE, memos)
  redirect "/memos/#{params['id']}"
end

get '/memos/:id/edit' do
  memos = read_memos
  @memo = memos[params['id']]
  erb :edit
end
