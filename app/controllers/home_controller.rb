# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to card_url(Card.order('RANDOM()').first)
  end
end
