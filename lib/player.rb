class Player
  attr_accessor :balance

  def self.TYPES
    [
      Player1,
      Player2,
      Player3,
      Player4
    ]
  end

  def initialize
    @balance = 0
    @bet = 0
  end

  def bet quantity = 0
    @balance -= quantity
    @bet += quantity
  end

  def pay quantity
    @bet = 0
    @balance += quantity
  end

  def lose_bet
    pay 0
  end

  def push
    pay bet
  end

  def bet_turn?(hole_cards, board_cards)
    raise NotImplementedError
  end

  def bet_river?(hole_cards, board_cards)
    raise NotImplementedError
  end
end
