# frozen_string_literal: true

module ApplicationHelper
  def natural_sort_by(collection, &block)
    collection.sort_by do |element|
      block.call(element).scan(/(\d+)|(\D+)/).map { |i, s| s.presence || i.to_i }
    end
  end
end
