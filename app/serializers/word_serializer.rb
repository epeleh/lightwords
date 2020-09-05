# frozen_string_literal: true

class WordSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :updated_at
end
