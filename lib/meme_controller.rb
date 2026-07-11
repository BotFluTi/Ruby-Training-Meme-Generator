# frozen_string_literal: true

require_relative 'response'

class MemeController
  def execute(_body)
    Response.new(redirect_url: 'generated.jpg')
  end
end
