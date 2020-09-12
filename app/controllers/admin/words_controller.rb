# frozen_string_literal: true

class Admin::WordsController < ApplicationController
  before_action :check_admin_authorization!

  def index
    @cards = Word.all
  end
end
