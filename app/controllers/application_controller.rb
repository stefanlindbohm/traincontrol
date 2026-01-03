# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper SVGHelper

  before_action :set_turbo_frame_variant

  private

  def set_turbo_frame_variant
    turbo_frame = turbo_frame_request_id
    request.variant = turbo_frame.to_sym if !turbo_frame.nil? && %w[modal].include?(turbo_frame)
  end
end
