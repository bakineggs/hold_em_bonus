class BruteForce < Player
  def initialize
    super
    @deck = Poker::Deck.new
  end

  def bet_turn?(hole_cards, board_cards)
    advantage(hole_cards, board_cards) > 0
  end

  def bet_river?(hole_cards, board_cards)
    advantage(hole_cards, board_cards) > 0
  end

  private
    def advantage(hole_cards, board_cards)
      advantage = 0
      #cards = @deck.cards - hole_cards - board_cards
      cards = @deck.cards.reject do |card|
        hole_cards.include?(card) || board_cards.include?(card)
      end
      combinations(cards, 5 - board_cards.length).each do |next_board_cards|
        board = board_cards + next_board_cards
        combinations(cards - next_board_cards, 2).each do |dealer_cards|
          advantage += Poker::Hand.new(*(hole_cards + board)) <=> Poker::Hand.new(*(dealer_cards + board))
        end
      end
      advantage
    end

    def combinations(cards, quantity)
      return cards.map{|card| [card]} if quantity == 1
      combinations = []
      cards = cards.clone # prevents the popping from modifying the passed in parameter
      while card = cards.pop
        combinations += combinations(cards, quantity - 1).map do |combination|
          combination + [card]
        end
      end
      combinations
    end
end
