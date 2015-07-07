require 'rubygems'
require 'sinatra'
require 'sinatra/config_file'
require 'haml'
require 'sass'
require 'plist'
require 'redcarpet'
require 'html/pipeline'
require './entry.rb'

class DayOneHtml < Sinatra::Base
  register Sinatra::ConfigFile

  config_file 'config.yml'

  def initialize
    super
    @entries_paths = settings.journals
    $stderr.puts "Journal paths: #{ @entries_paths.inspect }"
  end

  get '/' do
    @markdown = get_markdown
    @entries = get_entries

    haml :dayone, :format => :html5
  end

  get '/notags' do
    @markdown = get_markdown
    @entries = get_entries.select { |entry| entry.tags.empty? }
    haml :dayone, :format => :html5
  end

  get '/tag/:tag' do |tag|
    @markdown = get_markdown
    @entries = get_entries.select do |entry|
      entry.tags.include? tag
    end

    haml :dayone, :format => :html5
  end

  get '/photo/:id.jpg' do |id|
    entry = find_entry(id)
    redirect 404 unless entry.has_photo

    cache_control :public, max_age: 60
    content_type entry.photo_content_type
    entry.photo_data
  end

  get '/:style.css' do |style|
    content_type 'text/css', :charset => 'utf-8'
    scss style.to_sym
  end

  def find_entry(id)
    source, path = @entries_paths.detect { |source, path| File.exist?(path + id + '.doentry') }
    Entry.from_path(path + id + '.doentry', path + '../photos/' + id + '.jpg', source)
  end

  def get_entries()
    @entries = []

    $stderr.puts "Reading journal entries:"

    @entries_paths.each do |source, path|
      Dir.glob(path + '*.doentry') do |entry_path|

        $stderr.puts "\t#{entry_path}"

        photo_path = entry_path.sub('entries', 'photos').sub('.doentry', '.jpg')
        entry = Entry.from_path(entry_path, photo_path, source)
        if entry.date >= settings.startDate and entry.date <= settings.endDate
          @entries << Entry.from_path(entry_path, photo_path, source)
        end
      end
    end

    @entries.sort_by! do |e|
      e.date
    end
  end

  def get_markdown()
    HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter
    ], { gfm: true }
  end
end
