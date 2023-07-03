# frozen_string_literal: true

class Player
  attr_reader :name
  attr_accessor :bankroll, :hand

  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
    @hand = []
  end

  def make_bet(amount)
    self.bankroll -= amount
    raise ArgumentError, name.to_s if bankroll.negative?
  end

  def show_cards
    hand.each do |card|
      puts "#{card.name} - #{card.points}"
    end
  end

  def show_total
    puts "Очки: #{total}"
  end

  def show_balance
    puts "Баланс: #{bankroll}"
  end

  def total
    max_points = hand.map(&:points).sum
    aces_count = hand.find_all(&:ace?).count
    ace_points_diff = Deck::POINTS[:A] - Deck::ACE_ALT_VALUE

    while aces_count.positive? && max_points > Blackjack::LIMIT
      max_points -= ace_points_diff
      aces_count -= 1
    end
    max_points
  end

  def show_info
    puts name
    show_cards
    show_total
    show_balance
    puts '-' * 15
    puts
  end
end
