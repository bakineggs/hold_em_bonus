class PairsWithBoardDrawLogic < Player
  def bet_turn?(hole_cards, board_cards)
    [
      highest_card?(hole_cards, board_cards),
      pair?(hole_cards, board_cards),
      draws?(Poker::Hand.new(*(hole_cards + board_cards)))
    ].any?
  end

  def bet_river?(hole_cards, board_cards)
    hand = Poker::Hand.new *(hole_cards + board_cards)
    hole = Poker::Hand.new *hole_cards
    board = Poker::Hand.new *board_cards
    [
      highest_card?(hole_cards, board_cards) && !draws?(board),
      pair?(hole_cards, board_cards) && !draws?(board),
      hole.pair? && hole_cards.first.value >= board_cards.sort[2].value,
      !hole.pair? && pair?(hole_cards, board_cards.sort[2..3]),
      hole.pair? && hole_cards.first.value >= board_cards.sort[0].value && !strong_draws?(board),
      !hole.pair? && pair?(hole_cards, board_cards) && !strong_draws?(board),
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

    def strong_draws?(hand)
      hand.four_to_flush? || hand.open_ended? || hand.double_gutshot?
    end

    def draws?(hand)
      hand.four_to_flush? || hand.open_ended? || hand.gutshot?
    end
end
