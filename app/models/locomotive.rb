# frozen_string_literal: true

class Locomotive < ApplicationRecord
  belongs_to :command_station

  validates :name, presence: true
  validates :address, presence: true

  def decoder
    @decoder ||= TraincontrolBridge.instance.runtime.find_locomotive(address)
  end
end
