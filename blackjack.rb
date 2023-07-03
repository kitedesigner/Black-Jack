# frozen_string_literal: true

require_relative 'user'
require_relative 'dealer'
require_relative 'round'
require_relative 'deck'

class Blackjack
  attr_accessor :deck, :bank
  attr_reader :user, :dealer

  BET_AMOUNT = 10
  LIMIT = 21
  THRESHOLD = 17
  MIN_CARDS = 6

  def initialize
    @user = User.new 100
    @dealer = Dealer.new 100
    @deck = Deck.new
    @bank = 0
  end

  def start
    loop do
      Round.new(user, dealer, deck, bank).start
      exit_or_continue
    end
  end

  private

  def round_end_menu
    puts 'Раунд окончен. Продолжим?'
    puts '1 - продолжить'
    puts '2 - выход'
    print 'Выбор: '
    choice = gets.chomp.to_i
    raise StandardError unless [1, 2].include? choice

    choice
  rescue StandardError
    puts 'Неверный выбор, попробуйте еще.'
    retry
  end

  def exit_or_continue
    exit(0) if round_end_menu == 2
    system('cls')
  end
end
