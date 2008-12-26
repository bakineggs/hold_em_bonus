class Player
  attr_accessor :balance

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

  def bet_turn?(hole_cards, board_cards)
    return true if hole_cards.any?{|card| card.face == 'Ace'}
    hand = Poker::Hand.new *(hole_cards + board_cards)
    hand.pair? || hand.straight? || hand.flush?
  end

  def bet_river?(hole_cards, board_cards)
    return true if hole_cards.any?{|card| card.face == 'Ace'}
    hand = Poker::Hand.new *(hole_cards + board_cards)
    hand.pair? || hand.straight? || hand.flush?
  end
end
