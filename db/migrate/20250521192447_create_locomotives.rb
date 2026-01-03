# frozen_string_literal: true

class CreateLocomotives < ActiveRecord::Migration[7.1]
  def change
    create_table :locomotives do |t|
      t.timestamps
      t.references :command_station
      t.integer :address
      t.text :name
    end
  end
end
