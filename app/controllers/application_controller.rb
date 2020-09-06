# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def random_card
    card = Card.order(:used_at).limit(Card.count / 10).sample
    raise ActiveRecord::RecordNotFound, "Couldn't find random Card" if card.nil?
    card.update(used_at: Time.now.utc)
    card
  end
end
