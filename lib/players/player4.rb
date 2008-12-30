class Player4 < Player
  def bet_turn?(hole_cards, board_cards)
    hand = Poker::Hand.new *(hole_cards + board_cards)
    [
      highest_card?(hole_cards, board_cards),
      pair?(hole_cards, board_cards),
      hand.straight?,
      hand.flush?
    ].any?
  end

  def bet_river?(hole_cards, board_cards)
    hand = Poker::Hand.new *(hole_cards + board_cards)
    [
      Poker::Hand.new(*board_cards).pair? && highest_card?(hole_cards, board_cards),
      pair?(hole_cards, board_cards),
      hand.straight?,
      hand.flush?
    ].any?
  end

  private
    def highest_card?(hole_cards, board_cards)
      (14-board_cards.length..14).any? do |value|
        hole_cards.any?{|card| card.value == value} &&
        (value+1..14).all? do |higher|
          board_cards.any?{|card| card.value == higher}
        end
      end
    end

    def pair?(hole_cards, board_cards)
      Poker::Hand.new(*hole_cards).pair? ||
      hole_cards.any?{|hole_card| board_cards.any?{|board_card| hole_card.face == board_card.face}}
    end
end
