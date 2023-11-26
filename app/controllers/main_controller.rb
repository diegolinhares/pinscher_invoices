# frozen_string_literal: true

class MainController < ::ApplicationController
  before_action :authenticate_user!

  def index
    case ::Current.user
    in ::User
      redirect_to invoices_path
    else
      render 'main/index'
    end
  end
end
