# frozen_string_literal: true

require_relative 'player'

class User < Player
  def initialize(bankroll)
    name = 'Борис' # username_input
    super(name, bankroll)
  end

  private

  def username_input
    print 'Имя: '
    gets.chomp
  end
end
