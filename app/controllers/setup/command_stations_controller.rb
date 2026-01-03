# frozen_string_literal: true

module Setup
  class CommandStationsController < ApplicationController
    before_action :set_command_station
    before_action :override_adapter_from_param, only: :show

    def show; end

    def update
      @command_station.update(command_station_params)
      TraincontrolBridge.instance.restart

      redirect_to action: :show
    end
    alias create update

    private

    def set_command_station
      @command_station = CommandStation.first || CommandStation.new
    end

    def override_adapter_from_param
      if (adapter = params[:adapter]).present?
        @command_station.adapter = adapter
      end
    end

    def command_station_params
      params.require(:command_station).permit(:adapter, adapter_options: {})
    end
  end
end
