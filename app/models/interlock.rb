# frozen_string_literal: true

class Interlock < ApplicationRecord
  has_many :turnouts, dependent: :restrict_with_exception

  validates :name, presence: true
end
