# frozen_string_literal: true

class Card < ApplicationRecord
  has_many :words, -> { order(:id) }, dependent: :nullify

  before_save { self.used_at ||= Time.now.utc }

  scope :search, lambda { |text|
    return all if text.blank?

    number = text.delete('^0-9').presence
    where(id: Word.distinct.search(text).select(:card_id)).or(
      number ? where('CAST(cards.id as text) LIKE ?', "%#{number}%") : none
    )
  }

  validates :words, length: { is: 5, message: 'is the wrong size (should be 5 words)' }
end
