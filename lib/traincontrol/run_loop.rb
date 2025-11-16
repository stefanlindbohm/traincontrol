# frozen_string_literal: true

module Traincontrol
  class RunLoop
    attr_reader :interval, :stopped

    def initialize(interval, &block)
      @interval = interval
      @block = block
      @current_task = nil
      @current_start_time = nil
      @stopped = false

      tick
    end

    def stop
      @stopped = true
      @current_task&.cancel || @current_task&.wait
    end

    private

    attr_reader :current_start_time

    def tick
      return if @current_task&.pending? || stopped

      @current_start_time = Time.now
      @block.call

      return if stopped

      @current_task = Concurrent::ScheduledTask.execute(next_invocation_time) { tick }
    rescue Concurrent::CancelledOperationError
      @stopped = true
    rescue StandardError => e
      warn e
      warn e.class
      warn e.backtrace
    end

    def next_invocation_time
      next_invocation = interval - (Time.now - current_start_time)
      return 0 if next_invocation <= 0

      next_invocation
    end
  end
end
