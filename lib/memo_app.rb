# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

DATA_FILE = File.join(__dir__, 'memos.json')

def read_memos
  if File.exist?(DATA_FILE)
    JSON.parse(File.read(DATA_FILE))
  else
    write_json([])
    []
  end
end

def find_memo(memos, id)
  memos.find do |memo|
    id.to_i == memo['id']
  end
end

def get_next_id(memos)
  max_id = memos.map { |memo| memo['id'] }.max
  max_id.nil? ? 1 : max_id + 1
end

def write_json(memos)
  File.write(DATA_FILE, JSON.pretty_generate(memos))
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
  next_id = get_next_id(memos)
  memos << { 'id' => next_id, 'title' => params['title'], 'content' => params['content'] }
  write_json(memos)
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = read_memos
  @memo = find_memo(memos, params['id'])
  erb :show
end

delete '/memos/:id' do
  memos = read_memos
  memo = find_memo(memos, params['id'])
  memos.delete(memo)
  write_json(memos)
  redirect '/memos'
end

patch '/memos/:id' do
  memos = read_memos
  memo = find_memo(memos, params['id'])
  memo['title'] = params['title']
  memo['content'] = params['content']
  write_json(memos)
  redirect "/memos/#{params['id']}"
end

get '/memos/:id/edit' do
  memos = read_memos
  @memo = find_memo(memos, params['id'])
  erb :edit
end
