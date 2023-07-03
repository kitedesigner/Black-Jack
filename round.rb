# frozen_string_literal: true

require_relative 'deck'

class Round
  attr_reader :user, :dealer, :deck
  attr_accessor :bank

  BET_AMOUNT = 10
  LIMIT = 21
  THRESHOLD = 17
  MIN_CARDS = 6

  def initialize(user, dealer, deck, bank)
    @user = user
    @dealer = dealer
    @deck = deck
    @bank = bank
  end

  def start
    make_bets
    first_round
    second_round
    total_score
    define_winner
    reset_hands!
  end

  def first_round
    validate_deck!
    2.times { pull_card(user) }
    user.show_info

    2.times { pull_card(dealer) }
    dealer.show_placeholder
    print_bank
  end

  def second_round
    open = false
    case make_choice
    when 2
      pull_card user
    when 3
      open = true
    end
    pull_card(dealer) if dealer.total < THRESHOLD && !open
  end

  private

  def pull_card(player)
    player.hand.push(deck.pull_card)
  end

  def validate_deck!
    return unless deck.cards.count < MIN_CARDS

    puts 'Новая колода!'
    @deck = Deck.new
  end

  def total_score
    system('cls')
    user.show_info
    dealer.show_info
    print_bank
  end

  def define_winner
    if user.total > LIMIT
      print 'Перебор! '
      dealer_win
    elsif user_wins?
      user_win
    elsif dealer_wins?
      dealer_win
    else
      tie
    end
  end

  def dealer_wins?
    dealer.total > user.total && dealer.total <= LIMIT
  end

  def user_wins?
    user.total > dealer.total || dealer.total > LIMIT
  end

  def user_win
    puts 'Вы выиграли!'
    cash_to(user)
  end

  def dealer_win
    puts 'Дилер выиграл'
    cash_to(dealer)
  end

  def tie
    puts 'Ничья'
    cash_to(nil)
  end

  def cash_to(player)
    if player
      player.bankroll += bank
    else
      split = bank / 2
      dealer.bankroll += split
      user.bankroll += split
    end
    self.bank = 0
  end

  def make_choice
    puts '1 - пропустить'
    puts '2 - взять карту'
    puts '3 - открыться'
    print 'Выбор: '
    choice = gets.chomp.to_i
    raise StandardError unless (1..3).include? choice

    choice
  rescue StandardError
    puts 'Неверный выбор, попробуйте еще.'
    retry
  end

  def print_bank
    puts "\nБанк: #{bank}\n"
  end

  def make_bets
    [user, dealer].each { |player| player.make_bet BET_AMOUNT }
    self.bank += BET_AMOUNT * 2
  rescue ArgumentError => e
    bust_finish(e.message)
  end

  def reset_hands!
    [user, dealer].each { |player| player.hand.clear }
  end

  def bust_finish(looser_name)
    winner = [user, dealer].detect { |player| player.name != looser_name }
    puts "#{looser_name} больше не может делать ставок"
    puts "#{winner.name} выиграл!"
    exit(0)
  end
end
