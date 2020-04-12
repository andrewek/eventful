# == Schema Information
#
# Table name: eventful_events
#
#  id           :bigint           not null, primary key
#  action       :string           default(""), not null
#  associations :jsonb            not null
#  data         :jsonb            not null
#  description  :string           default(""), not null
#  resource     :string           default(""), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  parent_id    :bigint
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
  class Event < ApplicationRecord
  end
end
