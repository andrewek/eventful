# frozen_string_literal: true

module Eventful
  # Adds search function by data to Eventful::Event
  module DataSearchable
    extend ActiveSupport::Concern

    included do
      scope :by_data, lambda { |key, value|
        where(
          "data ->> :key = :value",
          key: key.to_s,
          value: value.to_s,
        )
      }
    end
  end
end
