# frozen_string_literal: true

module Eventful
  # Adds search by association to Eventful::Event
  module AssociationSearchable
    extend ActiveSupport::Concern

    included do
      scope :by_association, lambda { |key, value|
        where(
          "associations ->> :key = :value",
          key: key.to_s,
          value: value.to_s,
        )
      }
    end
  end
end
