require 'rubygems'
require 'poker'
require 'lib/game'
require 'lib/player'
(Dir.entries('lib/players') - ['.', '..']).each do |player|
  require "lib/players/#{player}"
end

players = Player.TYPES.map{|type| type.new}
game = Game.new(players)

highest = {}
lowest = {}
players.each do |player|
  highest[player] = 0
  lowest[player] = 0
end

1000.times do
  game.play_hand
  players.each do |player|
    if player.balance > highest[player]
      highest[player] = player.balance
    elsif player.balance < lowest[player]
      lowest[player] = player.balance
    end
  end
end

players.each do |player|
  puts "#{player.class}:"
  puts "  Balance: #{player.balance}"
  puts "  Highest: #{highest[player]}"
  puts "  Lowest: #{lowest[player]}"
end
