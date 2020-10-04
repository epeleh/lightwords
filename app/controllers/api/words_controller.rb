# frozen_string_literal: true

class Api::WordsController < ApplicationController
  before_action :check_admin_authorization!, only: %i[create update]
  after_action(only: :create) { AddCardsJob.perform_later if Word.unused.count >= 5 }

  def index
    render json: Word.search(params[:search].to_s.strip).order(:id)
  end

  def show
    render json: Word.find(params[:id])
  end

  def create
    if words_params.present?
      words = words_params.map(&Word.method(:new))
      words.each(&:save)
      words.map! { |word| word.valid? ? word : word.attributes.symbolize_keys.merge!({ errors: word.errors }) }
      return render json: words, status: (:unprocessable_entity if words.none? { |x| x.is_a? Word })
    end

    word = Word.new(word_params)
    return render json: word, status: :created if word.save
    render json: word.errors, status: :unprocessable_entity
  end

  def update
    word = Word.find(params[:id])
    return render json: word if word.update(word_params)
    render json: word.errors, status: :unprocessable_entity
  end

  private

  def word_params
    params.require(:word).permit(:text)
  end

  def words_params
    Array(params.permit(words: [:text])[:words])
  end
end
