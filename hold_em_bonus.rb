require 'rubygems'
require 'poker'
require 'lib/game'
require 'lib/player'

player = Player.new
game = Game.new([player])

1000.times do
  game.play_hand
end

puts player.balance
