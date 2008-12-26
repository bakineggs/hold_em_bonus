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
    hand = Poker::Hand.new *(hole_cards + board_cards)
    [
      hole_cards.any?{|card| card.face == 'Ace'},
      Poker::Hand.new(*hole_cards).pair?,
      hole_cards.any?{|hole_card| board_cards.any?{|board_card| hole_card.face == board_card.face}},
      hand.straight?,
      hand.flush?
    ].any?
  end

  def bet_river?(hole_cards, board_cards)
    hand = Poker::Hand.new *(hole_cards + board_cards)
    [
      hole_cards.any?{|card| card.face == 'Ace'},
      Poker::Hand.new(*hole_cards).pair?,
      hole_cards.any?{|hole_card| board_cards.any?{|board_card| hole_card.face == board_card.face}},
      hand.straight?,
      hand.flush?
    ].any?
  end
end
