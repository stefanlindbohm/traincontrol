# frozen_string_literal: true

class FormGroupComponent < ViewComponent::Base
  def initialize(title:, description: nil)
    super()

    @title = title
    @description = description
  end
end
