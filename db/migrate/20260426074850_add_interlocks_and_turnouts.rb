# frozen_string_literal: true

class AddInterlocksAndTurnouts < ActiveRecord::Migration[7.1]
  def change
    create_table :interlocks do |t|
      t.timestamps
      t.text :name
    end

    create_table :turnouts do |t|
      t.timestamps
      t.references :interlock
      t.references :command_station
      t.integer :address
      t.text :name
    end
  end
end
