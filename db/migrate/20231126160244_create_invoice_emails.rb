# frozen_string_literal: true

class CreateInvoiceEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :invoice_emails do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :email, null: false

      t.timestamps
    end

    add_index :invoice_emails, %i[email invoice_id], unique: true
  end
end
