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
  field :permalink,   type: String, default: -> {make_permalink}
  
  def make_permalink
    title.strip.downcase.gsub(/\W/,'-').squeeze("-").chomp("-") if title
  end
end


get '/:permalink' do
  begin
    @page = Page.find_by(permalink: params[:permalink])
  rescue
    pass
  end
  haml  :show
end

get '/pages' do
  @title = "Ladybug CMS: Page List"
  @pages = Page.all
  haml :index
end

get '/pages/new' do
  @page = Page.new
  haml :new
end

post '/pages/new' do
   page = Page.create(params[:page])
   redirect to("/pages/#{page.id}")
end

get '/pages/:id/edit' do
  @page = Page.find(params[:id])
  haml :edit
end

put '/pages/:id' do
  page = Page.find(params[:id])
  page.update_attributes(params[:page])
  redirect to("/pages/#{page.id}")
end

get '/pages/delete/:id' do
  @page = Page.find(params[:id])
  haml :delete
end

delete '/pages/:id' do
  Page.find(params[:id]).destroy
  redirect to('/pages')
end


get '/pages/:id' do
  @page = Page.find(params[:id])
  @title = @page.title
  haml :show
end


get '/' do
  "home"
end