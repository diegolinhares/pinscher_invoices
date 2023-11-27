# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Invoices::PdfMailer, type: :mailer do
  describe 'send_pdf' do
    before do
      allow(::File).to receive(:read).with('path/to/invoice.pdf').and_return('PDF_CONTENTS')
    end

    it 'renders the headers' do
      # Arrange
      invoice = create(:invoice)
      email = 'test@example.com'
      pdf_path = 'path/to/invoice.pdf'

      # Act
      mail = described_class.send_pdf(invoice, email, pdf_path)

      # Assert
      expect(mail.subject).to eq('Your invoice')
      expect(mail.to).to eq([email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      # Arrange
      invoice = create(:invoice)
      email = 'test@example.com'
      pdf_path = 'path/to/invoice.pdf'

      # Act
      mail = described_class.send_pdf(invoice, email, pdf_path)

      # Assert
      expect(mail.body.encoded).to match('Here is your invoice')
    end

    it 'attaches the PDF' do
      # Arrange
      invoice = create(:invoice)
      email = 'test@example.com'
      pdf_path = 'path/to/invoice.pdf'

      # Act
      mail = described_class.send_pdf(invoice, email, pdf_path)

      # Assert
      expect(mail.attachments['invoice.pdf']).to be_present
      expect(mail.attachments['invoice.pdf'].body.raw_source).to eq('PDF_CONTENTS')
    end
  end
end
