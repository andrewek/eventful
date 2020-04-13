# frozen_string_literal: true

module Eventful
  # Events have two different types of self-joins. This module concerns itself
  # with the Root/Progeny relationship
  #
  # Root/Progeny ties a series of events to a single inciting event. This is
  # useful when you have a series of events performed in response to some other
  # event.
  #
  # A root event may have several progeny, even if it only has one direct child.
  module Rootable
    extend ActiveSupport::Concern

    included do
      belongs_to :root, class_name: "Eventful::Event", optional: true
      has_many :progeny, class_name: "Eventful::Event", foreign_key: :root_id

      # An Event is a root event if it has no parents
      def root?
        root_id.nil?
      end

      # An event can be its own root, but we nix the foreign key to keep from
      # having an infinite cycle of queries.
      def calculated_root
        root || self
      end
    end
  end
end
