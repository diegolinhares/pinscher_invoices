# frozen_string_literal: true

# rubocop:disable Rails/ReversibleMigration
class AddInvoiceNumberToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :invoice_number, :integer
    execute <<-SQL
      CREATE SEQUENCE invoices_invoice_number_seq;
      ALTER TABLE invoices ALTER COLUMN invoice_number SET DEFAULT nextval('invoices_invoice_number_seq');
      ALTER SEQUENCE invoices_invoice_number_seq OWNED BY invoices.invoice_number;
    SQL
  end
end
# rubocop:enable Rails/ReversibleMigration
