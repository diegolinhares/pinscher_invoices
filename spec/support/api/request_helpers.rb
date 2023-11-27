# frozen_string_literal: true

module Api
  module RequestHelpers
    def json_response(response)
      ::JSON.parse(response.body, symbolize_names: true)
    end
  end
end

RSpec.configure do |config|
  config.include ::Api::RequestHelpers, type: :request
end
