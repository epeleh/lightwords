# frozen_string_literal: true

class AddCardsJob < ApplicationJob
  queue_as :default

  def perform
    (@semaphore ||= Mutex.new).synchronize do
      Word.unused.order('RANDOM()').each_slice(5) { |words| Card.create(words: words) }
    end
  end
end
