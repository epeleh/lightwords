# frozen_string_literal: true

class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.string :text, null: false, unique: true, index: true
      t.references :card, foreign_key: true
      t.timestamps
    end
  end
end
