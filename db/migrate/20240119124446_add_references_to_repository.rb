# frozen_string_literal: true

class AddReferencesToRepository < ActiveRecord::Migration[7.1]
  def change
    add_reference :repositories, :user, null: false, foreign_key: true
  end
end
