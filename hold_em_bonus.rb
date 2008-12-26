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

1000.times do
  game.play_hand
end

players.each do |type, player|
  puts "#{type}: #{player.balance}"
end
