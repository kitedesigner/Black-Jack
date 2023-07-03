# frozen_string_literal: true

require_relative 'card'

class Deck
  attr_reader :cards

  FACES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  POINTS = { J: 10, Q: 10, K: 10, A: 11 }.freeze
  SUITS = %w[♥ ♦ ♣ ♠].freeze
  ACE_ALT_VALUE = 1

  def initialize
    @cards = []
    create_deck
    shuffle!
  end

  def pull_card
    @cards.pop
  end

  private

  def create_deck
    FACES.each do |face|
      SUITS.each do |suit|
        points = POINTS.key?(face.to_sym) ? POINTS[face.to_sym] : face.to_i
        @cards << Card.new(suit: suit, points: points, face: face)
      end
    end
  end

  def shuffle!
    @cards.shuffle!
  end
end
