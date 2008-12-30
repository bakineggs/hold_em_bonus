require 'rubygems'
require 'poker'
require 'lib/game'
require 'lib/player'
(Dir.entries('lib/players') - ['.', '..']).each do |player|
  require "lib/players/#{player}"
end

players = Hash[*Player.TYPES.map do |type|
  [type, type.new]
end.flatten]
game = Game.new(players.values)

highest = {}
lowest = {}
players.each do |type, player|
  highest[player] = 0
  lowest[player] = 0
end

1000.times do
  game.play_hand
  players.each do |type, player|
    if player.balance > highest[player]
      highest[player] = player.balance
    elsif player.balance < lowest[player]
      lowest[player] = player.balance
    end
  end
end

players.each do |type, player|
  puts "#{type}:"
  puts "  Balance: #{player.balance}"
  puts "  Highest: #{highest[player]}"
  puts "  Lowest: #{lowest[player]}"
end
