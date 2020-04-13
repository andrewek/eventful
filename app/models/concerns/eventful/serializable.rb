# frozen_string_literal: true

module Eventful
  # Handle JSONB serialization/deserialization
  module Serializable
    extend ActiveSupport::Concern

    included do
      serialize :data, HashSerializer
      serialize :associations, HashSerializer
    end
  end
end
