# frozen_string_literal: true

class Word < ApplicationRecord
  belongs_to :card, optional: true

  before_validation { text.squish! }

  scope :used, -> { where.not(card_id: nil) }
  scope :unused, -> { where(card_id: nil) }
  scope :search, ->(text) { text.present? ? where('LOWER(words.text) LIKE ?', "%#{text}%".downcase) : all }

  validates :text, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 64 }
end
