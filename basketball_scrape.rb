require 'nokogiri'
require 'open-uri'
require 'pry'

#index page
basketball_html = open("http://www.usab.com/mens/national-team/roster.aspx")
basketball_index = Nokogiri::HTML(basketball_html)
players = {}

basketball_index.search("div.value a").each do |e|
  players[e.text] = e["href"]
end

def list(players)
  counter = 1
  players.each do |name,link|
    puts "#{counter}. #{name}"
    counter += 1
  end
end

def show(players)
  puts "Please enter player name"
  input = gets.chomp
  player_html = players.select do |name,html|
                  html if name == input
                end.values.join
  player_info(player_html)
end

#scraping player details
def player_info(player_html)
  player_link = open(player_html)
  player_url = Nokogiri::HTML(player_link)
  player_position = player_url.search("div.value span.full").first.text
  player_height = player_url.search("div.titleValuePair.hgt div.value span.full").first.text
  player_weight = player_url.search("div.titleValuePair.wgt div.value span.full").first.text
  player_birth = player_url.search("div.titleValuePair.dob div.value").first.text
  player_team = player_url.search("div.titleValuePair.nbaTeam div.value").first.text
  player_college = player_url.search("div.titleValuePair.collegeTeam div.value").first.text
  player_hometown = player_url.search("div.titleValuePair.homeTown div.value").first.text

  puts "Position: #{player_position}"
  puts "Height: #{player_height}"
  puts "Weight: #{player_weight}"
  puts "Date of Birth: #{player_birth}"
  puts "NBA Team: #{player_team}" 
  puts "School: #{player_college}"
  puts "Hometown: #{player_hometown}"
end

puts "Welcome to the USA BASKETBALL TEAM"
command = nil

while command != "exit"
  puts "Please type list, show, exit to see more info"
  command = gets.strip
  case command
  when "list"
    list(players)
  when "show"
    show(players)
  end
end