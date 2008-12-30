require 'rubygems'
require 'gruff'
require 'poker'
require 'lib/game'
require 'lib/player'
(Dir.entries('lib/players') - ['.', '..']).each do |player|
  require "lib/players/#{player}"
end

players = Player.TYPES.map{|type| type.new}
game = Game.new(players)

balances = {}
players.each do |player|
  balances[player] = [0]
end

1000.times do
  game.play_hand
  players.each do |player|
    balances[player].push player.balance
  end
end

graph = Gruff::Line.new
graph.title = 'Balances'

players.each do |player|
  puts "#{player.class}:"
  puts "  Balance: #{player.balance}"
  puts "  Highest: #{balances[player].max}"
  puts "  Lowest: #{balances[player].min}"
  graph.data player.class, balances[player]
end

graph.write('balances.png')
