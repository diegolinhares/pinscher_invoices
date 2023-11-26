# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authenticate_user!
    ::Current.user ||= ::User.find_by(id: session[:user_id])
  end
end
