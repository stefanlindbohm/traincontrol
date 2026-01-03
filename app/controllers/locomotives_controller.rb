# frozen_string_literal: true

class LocomotivesController < ApplicationController
  before_action :set_locomotive, only: %i[show update]

  def index
    @locomotives = Locomotive.order(:name).all
  end

  def show; end

  def new
    @locomotive = Locomotive.new(command_station: CommandStation.first)
  end

  def create
    @locomotive = Locomotive.new(new_locomotive_params)

    unless @locomotive.save
      render :new, status: :bad_request
      return
    end

    TraincontrolBridge.instance.runtime.register_locomotive(@locomotive.command_station_id, @locomotive.address)

    redirect_to @locomotive
  end

  def update
    @locomotive.decoder.update_attributes(locomotive_params)
    TraincontrolBridge.instance.runtime.update

    head :ok
  end

  private

  def set_locomotive
    @locomotive = Locomotive.find(params[:id])
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

  def new_locomotive_params
    params.require(:locomotive)
          .permit(:command_station_id, :address, :name)
  end
end
