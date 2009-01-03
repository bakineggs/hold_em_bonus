class PairsWithBoardDrawLogic < Player
  def bet_turn?(hole_cards, board_cards)
    @hole_cards = hole_cards
    @board_cards = board_cards
    [
      highest_card?,
      pair?,
      draws?(hand)
    ].any?
  end

  def bet_river?(hole_cards, board_cards)
    @hole_cards = hole_cards
    @board_cards = board_cards
    [
      (highest_card? || pair?) && !draws?(board),
      second_pair?,
      fourth_pair? && !strong_draws?(board),
      hand.straight?,
      hand.flush?
    ].any?
  end

  private
    def hand(cards = nil)
      cards ||= @hole_cards + @board_cards
      @hands ||= {}
      @hands[cards] ||= Poker::Hand.new *cards
    end

    def hole
      hand(@hole_cards)
    end

    def board
      hand(@board_cards)
    end

    def highest_card?
      (14-@board_cards.length..14).any? do |value|
        @hole_cards.any?{|card| card.value == value} &&
        (value+1..14).all? do |higher|
          @board_cards.any?{|card| card.value == higher}
        end
      end
    end

    def first_pair?
      nth_pair?(0)
    end

    def second_pair?
      nth_pair?(1)
    end

    def third_pair?
      nth_pair?(2)
    end

    def fourth_pair?
      nth_pair?(3)
    end

    def nth_pair?(n)
      values = @board_cards.map{|card| card.value}.uniq.sort.reverse
      n = values.length - 1 if n >= values.length
      paired_hole_values.any? do |value|
        value >= values[n]
      end
    end

    def pair?
      paired_hole_values.length > 0
    end

    def paired_hole_values
      cards = @hole_cards + @board_cards
      @paired_hole_values ||= {}
      @paired_hole_values[cards] ||= [@hole_cards.select do |hole_card|
        @board_cards.find{|board_card| hole_card.value == board_card.value}
      end.map{|card| card.value}, hole.pair? ? @hole_cards.first.value : nil].flatten.uniq.compact
    end

    def strong_draws?(hand)
      hand.four_to_flush? || hand.open_ended? || hand.double_gutshot?
    end

    def draws?(hand)
      hand.four_to_flush? || hand.open_ended? || hand.gutshot?
    end
end
