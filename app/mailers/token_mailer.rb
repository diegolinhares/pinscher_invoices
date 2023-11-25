# frozen_string_literal: true

class TokenMailer < ::ApplicationMailer
  def send_token(user)
    mail to: user.email, subject: 'Your access token' do |format|
      format.html do
        render 'token_mailer/send_token', locals: { token: user.token_value }
      end
    end
  end
end
