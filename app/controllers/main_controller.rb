# frozen_string_literal: true

class MainController < ::ApplicationController
  before_action :authenticate_user!

  def index; end
end
