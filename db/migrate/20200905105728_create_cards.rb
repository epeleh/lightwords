# frozen_string_literal: true

class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.datetime :used_at, null: false
      t.timestamps
    end
  end
end
