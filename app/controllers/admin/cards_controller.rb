# frozen_string_literal: true

class Admin::CardsController < ApplicationController
  before_action :check_admin_authorization!

  def index
    @cards = Card.all
  end
end
