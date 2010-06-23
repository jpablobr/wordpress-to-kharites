#!/usr/bin/env ruby
require 'rubygems'
require 'hpricot'
require 'time'
require 'sequel'

# Change this to load the DB for your Kharites instance
DB = Sequel.connect('sqlite://blog.db')
puts DB.class

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'note'

if ARGV.length == 0
  puts 'I require an XML file name to be passed as an argument.'
  exit 1
end

file = File.new(ARGV[0])

doc = Hpricot( File.open(file) )

(doc/"item").each do |item|
  if item.search("wp:post_type").first.inner_text == "post" and item.search("wp:status").first.inner_text == "publish" then

    is_private = ( item.search("wp:status").first.inner_text == "private" )
    tags = item.search("category[@domain='tag']").collect(&:inner_text).uniq
    tags = tags.map { |t| t.downcase }.sort.uniq
    
    next if item.search("wp:post_type").first.inner_text != "post"
    
    post_id = item.search("wp:post_id").first.inner_text.to_i
    title = item.search("title").first.inner_text.gsub(/:/, '')
    slug = title.empty?? nil : title.strip.slugize
    time = Time.parse item.search("wp:post_date").first.inner_text
    link = item.search("link").first.inner_text
    
    content = item.search("content:encoded").first.inner_text.to_s
    
    if content.strip.empty?
      puts "Failed to parse noteId #{post_id}:#{title}"
      next
    end
    
    begin
      note = Note.new( 
                      :id => post_id, 
                      :title => title, 
                      :tags => tags.join(' '), 
                      :body => content, 
                      :created_at => time, 
                      :slug => Note.make_slug(title)
                      )
      note.save
      puts "Saved note: id ##{note.id} #{title}"

    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      puts "ERROR! could not save note #{title}"
      raise
    end 
  end
end
