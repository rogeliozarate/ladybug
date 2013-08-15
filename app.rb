require 'sinatra'
require 'sinatra/reloader' if development?
require 'mongoid'
require 'haml'
require 'sass'
require 'redcarpet'

configure :development do
  enable :logging, :dump_errors, :run, :sessions
  Mongoid.load!("config/mongoid.yml")
end

class Page
  include Mongoid::Document
  field :title,       type: String
  field :content,     type: String
end


get '/pages' do
  @title = "Ladybug CMS: Page List"
  @pages = Page.all
  haml :index
end

get '/' do
  "home"
end