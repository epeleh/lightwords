# frozen_string_literal: true

class Admin::CardsController < ApplicationController
  def index
    @cards = Card.all
  end
end
