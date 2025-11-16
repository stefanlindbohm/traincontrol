# frozen_string_literal: true

class Throttler
  attr_reader :interval, :scheduled_task

  DEFAULT_INTERVAL = 0.5

  def initialize(interval: DEFAULT_INTERVAL)
    @interval = interval
    @scheduled_task = nil
    @last_invocation = nil
    @mutex = Mutex.new
  end

  def throttle(&block)
    @mutex.synchronize do
      if @last_invocation.nil? || (Time.now.to_f - @last_invocation) > @interval
        block.call
        @last_invocation = Time.now.to_f
      else
        delay = @last_invocation + @interval - Time.now.to_f
        scheduled_task&.cancel unless scheduled_task&.complete?
        @scheduled_task = Concurrent::ScheduledTask.execute(delay) do
          @last_invocation = Time.now.to_f
          block.call
        end
      end
    end
  end

  def wait
    scheduled_task&.wait(wait_timeout)
  end

  private

  attr_reader :last_invocation

  def wait_timeout
    interval + 1
  end
end
