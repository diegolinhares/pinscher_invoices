# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token_value, null: false
      t.datetime :expires_at, null: false
      t.boolean :active, default: false

      t.timestamps
    end

    add_index :tokens, :token_value, unique: true
  end
end
