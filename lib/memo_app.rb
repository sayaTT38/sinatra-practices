# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

DATA_FILE = File.join(__dir__, 'memos.json')

def read_data
  if File.exist?(DATA_FILE)
    JSON.parse(File.read(DATA_FILE))
  else
    data = {
      'last_id' => 0,
      'memos' => {}
    }
    write_json(data)
    data
  end
end

def read_memos(data)
  memos = data['memos']
  memos.transform_keys(&:to_i)
end

def find_memo(memos, id)
  memos[id.to_i]
end

def get_next_id(data)
  data['last_id'] + 1
end

def write_json(data)
  File.write(DATA_FILE, JSON.generate(data))
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
  data = read_data
  @memos = read_memos(data)
  erb :top
end

post '/memos' do
  data = read_data
  memos = read_memos(data)
  next_id = get_next_id(data)
  data['last_id'] = next_id
  memos[next_id] = { 'id' => next_id, 'title' => params['title'], 'content' => params['content'] }
  data['memos'] = memos
  write_json(data)
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  data = read_data
  memos = read_memos(data)
  @memo = find_memo(memos, params['id'])
  erb :show
end

delete '/memos/:id' do
  data = read_data
  memos = read_memos(data)
  memos.delete(params['id'].to_i)
  data['memos'] = memos
  write_json(data)
  redirect '/memos'
end

patch '/memos/:id' do
  data = read_data
  memos = read_memos(data)
  memo = find_memo(memos, params['id'])
  memo['title'] = params['title']
  memo['content'] = params['content']
  data['memos'] = memos
  write_json(data)
  redirect "/memos/#{params['id']}"
end

get '/memos/:id/edit' do
  data = read_data
  memos = read_memos(data)
  @memo = find_memo(memos, params['id'])
  erb :edit
end
