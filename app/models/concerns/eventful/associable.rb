# frozen_string_literal: true

module Eventful
  # Adds query methods on the including class to find associated events
  module Associable
    extend ActiveSupport::Concern

    class_methods do
      # SomeClass.events -> all events with a resource of that class
      def events
        Eventful::Event.by_resource(
          to_s.underscore,
        ).order(
          occurred_at: :desc,
        )
      end
    end

    included do
      # some_object.events -> sall events tied to that record specifically
      def events
        key_name = self.class.to_s.underscore + "_id"

        Eventful::Event.by_association(
          key_name,
          id,
        ).order(
          occurred_at: :desc,
        )
      end
    end
  end
end
