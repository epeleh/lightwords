# frozen_string_literal: true

class Card < ApplicationRecord
  has_many :words, dependent: :nullify

  before_save { self.used_at ||= Time.now.utc }

  validates :words, length: { is: 5, message: 'is the wrong size (should be 5 words)' }
end
