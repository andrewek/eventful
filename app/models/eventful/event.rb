# == Schema Information
#
# Table name: eventful_events
#
#  id           :bigint           not null, primary key
#  action       :string           default(""), not null
#  associations :jsonb
#  data         :jsonb
#  description  :string           default(""), not null
#  occurred_at  :datetime
#  resource     :string           default(""), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  parent_id    :bigint
#  root_id      :bigint
#
# Indexes
#
#  index_eventful_events_on_action        (action)
#  index_eventful_events_on_associations  (associations) USING gin
#  index_eventful_events_on_data          (data) USING gin
#  index_eventful_events_on_parent_id     (parent_id)
#  index_eventful_events_on_resource      (resource)
#
module Eventful
  # Represent an Event
  #
  # Assumptions:
  # + Related records are on conventionally set up tables
  # + :data will only be queried by top-level keys
  #
  # We do not make events directly, and instead go through the provided service
  # object.
  class Event < ApplicationRecord
    serialize :data, HashSerializer
    serialize :associations, HashSerializer

    validates :resource, presence: true
    validates :action, presence: true
    validates :description, presence: true
    validates :occurred_at, presence: true

    belongs_to :parent, class_name: "Eventful::Event", optional: true
    belongs_to :root, class_name: "Eventful::Event", optional: true
    has_many :children, class_name: "Eventful::Event", foreign_key: :parent_id
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
