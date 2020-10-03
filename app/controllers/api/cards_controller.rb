# frozen_string_literal: true

class Api::CardsController < ApplicationController
  def index
    render json: Card.includes(:words).search(params[:search].to_s.strip).order(:id)
  end

  def show
    render json: params[:id] == 'rand' ? random_card : Card.find(params[:id])
  end
end
