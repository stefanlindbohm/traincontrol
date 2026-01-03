# frozen_string_literal: true

class CreateCommandStations < ActiveRecord::Migration[7.1]
  def change
    create_table :command_stations do |t|
      t.timestamps
      t.text :adapter
      t.json :adapter_options
    end
  end
end
