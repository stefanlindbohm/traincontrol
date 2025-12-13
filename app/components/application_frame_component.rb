# frozen_string_literal: true

class ApplicationFrameComponent < ViewComponent::Base
  AVAILABLE_TABS = %i[driver setup].freeze

  def initialize(
    title:, current_tab:, back_url: nil, back_title: nil, container_class: nil,
    show_subnavigation_on_small_screens: false
  )
    raise ArgumentError, <<~TEXT unless AVAILABLE_TABS.include?(current_tab)
      current_tab must be one of #{AVAILABLE_TABS.join(', ')}
    TEXT

    super()

    @title = title
    @current_tab = current_tab
    @back_url = back_url
    @back_title = back_title
    @container_class = container_class
    @show_subnavigation_on_small_screens = show_subnavigation_on_small_screens
  end

  def navigation_items
    [
      [:driver, 'Driver', 'rc_loco', locomotives_path, nil],
      [:setup, 'Setup', 'heroicons/wrench-screwdriver', setup_general_settings_path, setup_root_path]
    ]
  end
end
