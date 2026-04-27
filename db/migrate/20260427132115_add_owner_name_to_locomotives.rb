# frozen_string_literal: true

class AddOwnerNameToLocomotives < ActiveRecord::Migration[7.1]
  def change
    add_column :locomotives, :owner_name, :text
  end
end
