# frozen_string_literal: true

class Turnout < ApplicationRecord
  belongs_to :interlock
  belongs_to :command_station

  validates :name, presence: true
  validates :address, presence: true

  def output
    @output ||= TraincontrolBridge.instance.runtime.find_accessory_output(address)
  end
end
