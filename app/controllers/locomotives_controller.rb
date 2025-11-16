# frozen_string_literal: true

class LocomotivesController < ApplicationController
  before_action :set_locomotive, only: %i[show update]

  def index
    @locomotives = $traincontrol.locomotives
  end

  def show; end

  def update
    @locomotive.update_attributes(locomotive_params)
    $traincontrol.update

    head :ok
  end

  private

  def set_locomotive
    @locomotive = $traincontrol.locomotives[params[:id].to_i]
  end

  def locomotive_params
    params.require(:locomotive)
          .permit(:speed, :direction, :lights, :f1, :f2, :f3, :f4)
          .to_hash
          .transform_keys(&:to_sym)
          .tap { _1[:speed] = _1[:speed].to_i if _1.key?(:speed) }
          .tap { _1[:direction] = _1[:direction].to_sym if _1.key?(:direction) }
          .tap { _1[:lights] = _1[:lights].to_i.positive? if _1.key?(:lights) }
          .tap { _1[:f1] = _1[:f1].to_i.positive? if _1.key?(:f1) }
          .tap { _1[:f2] = _1[:f2].to_i.positive? if _1.key?(:f2) }
          .tap { _1[:f3] = _1[:f3].to_i.positive? if _1.key?(:f3) }
          .tap { _1[:f4] = _1[:f4].to_i.positive? if _1.key?(:f4) }
  end
end
