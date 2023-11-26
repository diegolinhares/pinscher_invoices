# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.date :issue_date, null: false
      t.text :company, null: false
      t.text :billing_to, null: false
      t.integer :total_value_cents, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
