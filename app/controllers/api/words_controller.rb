# frozen_string_literal: true

class Api::WordsController < ApplicationController
  before_action :check_admin_authorization!, only: %i[create update]

  def index
    render json: Word.all
  end

  def show
    render json: Word.find(params[:id])
  end

  def create
    @word = Word.new(word_params)
    if @word.save
      AddCardsJob.perform_later if Word.unused.count >= 5
      render json: @word, status: :created
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  def update
    @word = Word.find(params[:id])
    if @word.update(word_params)
      render json: @word
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  private

  def word_params
    params.permit(:text)
  end
end
