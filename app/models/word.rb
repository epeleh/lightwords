# frozen_string_literal: true

class Word < ApplicationRecord
  belongs_to :card, optional: true

  scope :used, -> { where.not(card_id: nil) }
  scope :unused, -> { where(card_id: nil) }

  validates :text, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 64 }
end
