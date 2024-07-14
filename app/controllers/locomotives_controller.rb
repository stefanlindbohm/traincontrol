# frozen_string_literal: true

class LocomotivesController < ApplicationController
  before_action :set_locomotive, only: %i[show update]

  def index
    @locomotives = TraincontrolUniverse.instance.locomotives
  end

  def show; end

  def update
    @locomotive.update_attributes(locomotive_params)
    TraincontrolUniverse.instance.update

    head :ok
  end

  private

  def set_locomotive
    @locomotive = TraincontrolUniverse.instance.locomotives[params[:id].to_i]
  end

  def locomotive_params
    params.require(:locomotive)
          .permit(:speed, :direction, :lights)
          .to_hash
          .transform_keys(&:to_sym)
          .tap { _1[:direction] = _1[:direction].to_sym if _1.key?(:direction) }
          .tap { _1[:lights] = _1[:lights].to_i.positive? if _1.key?(:lights) }
  end
end
