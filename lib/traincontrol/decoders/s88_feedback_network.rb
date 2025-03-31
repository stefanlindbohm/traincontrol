# frozen_string_literal: true

module Traincontrol
  module Decoders
    class S88FeedbackNetwork
      class Contact
        attr_reader :feedback_network, :index, :active

        def initialize(feedback_network, index)
          @feedback_network = feedback_network
          @index = index
          @active = false
          @event_listeners = []
        end

        def add_listener(listener)
          @event_listeners << listener
        end

        def set(active)
          return if @active == active

          @active = active
          @event_listeners.each { _1.call(self) }
          # puts "Contact #{index} changed to #{@active}"
        end
      end
      attr_reader :contacts

      def initialize(number_of_contacts)
        @contacts = Array.new(number_of_contacts) { Contact.new(self, _1) }
        @event_listeners = []
      end

      def set_contacts(module_attributes)
        module_attributes.each do |attributes|
          offset = (attributes[:module_number] - 1) * 16
          attributes[:contacts].each_with_index do |contact, i|
            index = offset + i
            break if index >= @contacts.length

            @contacts[index].set(contact)
          end
        end
      end
    end
  end
end
