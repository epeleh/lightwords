# frozen_string_literal: true

class Admin::WordsController < ApplicationController
  def index
    @cards = Word.all
  end
end
