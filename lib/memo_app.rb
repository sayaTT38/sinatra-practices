# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

DB_NAME = 'memo_app'
TABLE_NAME = 'memos'

def connect_db
  PG.connect(
    dbname: DB_NAME,
    user: 'postgres',
    password: ENV['DB_PASSWORD']
  )
end

def read_memos(conn)
  result = conn.exec("SELECT * FROM #{TABLE_NAME};")
  result.to_a
end

def delete_memo(conn, id)
  conn.exec_params(
    "DELETE FROM #{TABLE_NAME} WHERE id = $1;",
    [id]
  )
end

def save_new_memo(conn, title, content)
  conn.exec_params(
    "INSERT INTO #{TABLE_NAME} (title,content) values ($1, $2);",
    [title, content]
  )
end

def edit_memo(conn, id, title, content)
  conn.exec_params(
    "UPDATE #{TABLE_NAME} SET title = $1, content = $2 WHERE id = $3;",
    [title, content, id]
  )
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
  conn = connect_db
  @memos = read_memos(conn)
  conn.close
  erb :top
end

post '/memos' do
  conn = connect_db
  save_new_memo(conn, params['title'], params['content'])
  conn.close
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  conn = connect_db
  memos = read_memos(conn)
  @memo = memos.find { |memo| memo['id'].to_i == params['id'].to_i }
  conn.close
  erb :show
end

delete '/memos/:id' do
  conn = connect_db
  delete_memo(conn, params['id'].to_i)
  conn.close
  redirect '/memos'
end

patch '/memos/:id' do
  conn = connect_db
  edit_memo(conn, params['id'].to_i, params['title'], params['content'])
  conn.close
  redirect "/memos/#{params['id']}"
end

get '/memos/:id/edit' do
  conn = connect_db
  memos = read_memos(conn)
  @memo = memos.find { |memo| memo['id'].to_i == params['id'].to_i }
  conn.close
  erb :edit
end
