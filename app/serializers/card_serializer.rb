# frozen_string_literal: true

class CardSerializer < ActiveModel::Serializer
  has_many :words
  attributes :id, :used_at, :created_at, :updated_at
end
