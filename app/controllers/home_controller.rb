# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to card_url(random_card)
  end
end
