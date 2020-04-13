# frozen_string_literal: true

require "test_helper"

module Eventful
  class AssociableTest < ActiveSupport::TestCase
    extend Minitest::Spec::DSL

    before(:all) do
      Eventful::Event.destroy_all
    end

    # Class Method - all events of that resource
    describe ".events" do
      it "queries appropriately" do
        matching_event_1 = FactoryBot.create(
          :event,
          resource: "echidna",
          occurred_at: 1.hour.ago,
        )

        matching_event_2 = FactoryBot.create(
          :event,
          resource: "echidna",
          occurred_at: 2.days.ago,
        )

        non_matching_event = FactoryBot.create(
          :event,
          resource: "wallaby",
        )

        result = Echidna.events

        assert_equal(result, [matching_event_1, matching_event_2])
        refute_includes(result, non_matching_event)
      end
    end

    # Instance method -- events for that particular record
    describe "#events" do
      it "queries appropriately" do
        matching_event_1 = FactoryBot.create(
          :event,
          associations: {
            echidna_id: 7,
          },
          occurred_at: 1.minute.ago,
        )

        matching_event_2 = FactoryBot.create(
          :event,
          associations: {
            echidna_id: 7,
          },
          occurred_at: 1.day.ago,
        )

        non_matching_event_1 = FactoryBot.create(
          :event,
          resource: "echidna",
          associations: {},
        )

        non_matching_event_2 = FactoryBot.create(
          :event,
          associations: {
            echidna_id: 14,
          },
        )

        e = Echidna.new(7)
        result = e.events

        assert_equal(result, [matching_event_1, matching_event_2])
        refute_includes(result, non_matching_event_1)
        refute_includes(result, non_matching_event_2)
      end
    end
  end
end

# Test Class
Echidna = Struct.new(:id) do
  include Eventful::Associable
end
