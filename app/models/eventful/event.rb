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
    include Eventful::Parentable
    include Eventful::Rootable

    serialize :data, HashSerializer
    serialize :associations, HashSerializer

    validates :resource, presence: true
    validates :action, presence: true
    validates :description, presence: true
    validates :occurred_at, presence: true
  end
end
