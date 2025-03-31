# frozen_string_literal: true

class SensorTimer
  attr_reader :distance, :contact_a, :contact_b

  def initialize(distance, contact_a, contact_b, locomotive)
    @distance = distance
    @contact_a = contact_a
    @contact_b = contact_b
    @locomotive = locomotive
    @test_speed = 16
    @start_time = nil
    @start_contact = nil

    @contact_a.add_listener(-> { register_change(_1) })
    @contact_b.add_listener(-> { register_change(_1) })

    @locomotive.speed = @test_speed
    TraincontrolUniverse.instance.update
  end

  def register_change(contact)
    return unless contact.active

    if @start_contact.nil? || @start_contact == contact
      @start_contact = contact
      @start_time = Time.new
    elsif contact != @start_contact && @start_time.present?
      finish
      @start_time = nil
    end
  end

  def finish
    time = Time.new - @start_time
    velocity = distance / time
    real_world_speed = velocity * 3.6 * 87

    puts "Finished timer in #{time} s. Loco on speed level #{@locomotive.speed} running at #{velocity} m/s, real world equivalent #{real_world_speed} km/h"

    @test_speed += 16
    @test_speed = 0 if @test_speed > 80
    @locomotive.speed = @test_speed
    TraincontrolUniverse.instance.update
  end
end
