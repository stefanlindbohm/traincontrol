# frozen_string_literal: true

class TurnoutsController < ApplicationController
  before_action :set_interlock
  before_action :set_turnout, only: %i[update]

  def new
    @turnout = Turnout.new(command_station: CommandStation.first, interlock: @interlock)
  end

  def create
    @turnout = Turnout.new(new_turnout_params)

    unless @turnout.save
      render :new, status: :bad_request
      return
    end

    TraincontrolBridge.instance.runtime.register_accessory_output(@turnout.command_station_id, @turnout.address)

    redirect_to interlocks_path
  end

  def update
    @turnout.output.update_attributes(turnout_params.merge(active: true))
    TraincontrolBridge.instance.runtime.update

    head :ok
  end

  private

  def set_interlock
    @interlock = Interlock.find(params[:interlock_id])
  end

  def set_turnout
    @turnout = Turnout.find(params[:id])
  end

  def turnout_params
    params.require(:turnout)
          .permit(:thrown)
          .to_hash
          .transform_keys(&:to_sym)
          .tap { _1[:thrown] = _1[:thrown].to_i.positive? if _1.key?(:thrown) }
  end

  def new_turnout_params
    params.require(:turnout)
          .permit(:command_station_id, :address, :name)
          .merge(interlock: @interlock)
  end
end
