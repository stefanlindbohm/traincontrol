# frozen_string_literal: true

class InputComponent < ViewComponent::Base
  def initialize(label:, description: nil)
    super()

    @label = label
    @description = description
  end
end
