# == Schema Information
#
# Table name: eventful_events
#
#  id           :bigint           not null, primary key
#  action       :string           default(""), not null
#  associations :jsonb
#  data         :jsonb
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
require 'test_helper'

module Eventful
  class EventTest < ActiveSupport::TestCase
    describe "#data" do
      it "serializes as a hash with symbol keys" do
        e = Event.create!(
          description: "wombat created",
          resource: "wombat",
          action: "created",
          data: {
            "foo" => "bar",
          },
          associations: {},
        )

        assert_includes(e.data.keys, :foo)
      end
    end

    describe "#associations" do
      it "serializes as a hash with symbol keys" do
        e = Event.create!(
          description: "wombat created",
          resource: "wombat",
          action: "created",
          data: {},
          associations: {
            "wombat_id" => 3,
          },
        )

        assert_includes(e.associations.keys, :wombat_id)
      end
    end

    describe "#new" do
      it "is invalid without a description" do
        e = Event.new(description: "")
        refute(e.valid?)
        assert_includes(e.errors[:description], "can't be blank")
      end

      it "is invalid without a resource" do
        e = Event.new(resource: "")
        refute(e.valid?)
        assert_includes(e.errors[:resource], "can't be blank")
      end

      it "is invalid without an action" do
        e = Event.new(action: "")
        refute(e.valid?)
        assert_includes(e.errors[:action], "can't be blank")
      end

      it "defaults to empty data" do
        e = Event.new
        assert_equal(e.data, {})
      end

      it "defaults to empty associations" do
        e = Event.new
        assert_equal(e.associations, {})
      end
    end
  end
end
