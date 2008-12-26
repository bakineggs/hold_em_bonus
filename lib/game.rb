class Game
  attr_accessor :deck
  attr_accessor :dealer_cards
  attr_accessor :player_cards
  attr_accessor :board_cards
  attr_accessor :players

  def initialize(players)
    self.players = players
    self.deck = Poker::Deck.new
  end

  def play_hand
    self.deck.shuffle
    deal
    play_flop
    play_turn
    play_river
    pay_bets
  end

  private
    def deal
      self.player_cards = deck.next 2
      self.dealer_cards = deck.next 2
      players.each do |player|
        player.bet 1
      end
    end

    def play_flop
      players.each do |player|
        player.bet 2
      end
      self.board_cards = deck.next 3
    end

    def play_turn
      players.each do |player|
        player.bet 1 if player.bet_turn?(player_cards, board_cards)
      end
      self.board_cards += deck.next 1
    end

    def play_river
      players.each do |player|
        player.bet 1 if player.bet_river?(player_cards, board_cards)
      end
      self.board_cards += deck.next 1
    end

    def pay_bets
      player_hand = Poker::Hand.new *(player_cards + board_cards)
      dealer_hand = Poker::Hand.new *(dealer_cards + board_cards)
      if player_hand > dealer_hand
        payout_offset = player_hand >= lowest_straight ? 0 : -1
        players.each do |player|
          player.pay player.bet * 2 + payout_offset
        end
      else
        players.each do |player|
          player.lose_bet
        end
      end
    end

    def lowest_straight
      @lowest_straight ||= Poker::Hand.new(
        Poker::Card.new('Spades', 'Ace'),
        Poker::Card.new('Spades', '2'),
        Poker::Card.new('Diamonds', '3'),
        Poker::Card.new('Clubs', '4'),
        Poker::Card.new('Hearts', '5')
      )
    end
end
