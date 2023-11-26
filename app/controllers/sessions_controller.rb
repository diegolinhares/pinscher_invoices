# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    input = {
      token_value: params[:token]
    }

    ::Tokens::Find.call(input) do |on|
      on.success { create_session_for(_1[:user]) }
      on.failure(:invalid_token) { render_error_message }
      on.failure(:expired_token) { render_error_message }
      on.unknown { raise _1.inspect.errors }
    end
  end

  def show
    input = {
      token_value: params[:token]
    }

    ::Tokens::Activate.call(input) do |on|
      on.success { create_session_for(_1[:user]) }
      on.failure(:invalid_token) { render_error_message }
      on.failure(:expired_token) { render_error_message }
      on.unknown { raise _1.inspect.errors }
    end
  end

  def destroy
    session[:user_id] = nil

    ::Current.user = nil

    flash[:notice] = 'Signed out successfully'

    redirect_to root_path
  end

  private

  def create_session_for(user)
    session[:user_id] = user.id

    ::Current.user = user

    flash[:success] = 'Signed in successfully'

    redirect_to root_path
  end

  def render_error_message
    flash[:alert] = 'Invalid or expired token'

    redirect_to root_path
  end
end
