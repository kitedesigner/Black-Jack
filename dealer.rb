# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  DEALER = 'Дилер'

  def initialize(bankroll)
    super(DEALER, bankroll)
  end

  def show_placeholder
    puts name
    puts '*' * 8
    puts '*' * 8
    show_balance
    puts '-' * 15
  end
end
