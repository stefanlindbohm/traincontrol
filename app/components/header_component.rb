# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(text)
    super()

    @text = text
  end
end
