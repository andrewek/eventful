# frozen_string_literal: true

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
require "test_helper"

module Eventful
  class EventTest < ActiveSupport::TestCase
    extend Minitest::Spec::DSL

    before(:all) do
      Eventful::Event.destroy_all
    end

    describe ".by_resource" do
      it "matches one resource" do
        matching_event = FactoryBot.create(
          :event,
          resource: "echidna",
        )

        FactoryBot.create(
          :event,
          resource: "wallaby",
        )

        result = Eventful::Event.by_resource("echidna")

        assert_equal([matching_event], result)
      end

      it "matches many resources" do
        matching_event_1 = FactoryBot.create(
          :event,
          resource: "echidna",
        )

        matching_event_2 = FactoryBot.create(
          :event,
          resource: "echidna",
        )

        matching_event_3 = FactoryBot.create(
          :event,
          resource: "wallaby",
        )

        result = Eventful::Event.by_resource("echidna", "wallaby")

        assert_includes(result, matching_event_1)
        assert_includes(result, matching_event_2)
        assert_includes(result, matching_event_3)
      end
    end

    describe ".by_action" do
      it "matches one action" do
        matching_event = FactoryBot.create(
          :event,
          action: "witnessed",
        )

        FactoryBot.create(
          :event,
          action: "seen",
        )

        result = Eventful::Event.by_action("witnessed")

        assert_equal([matching_event], result)
      end

      it "matches many actions" do
        matching_event_1 = FactoryBot.create(
          :event,
          action: "witnessed",
        )

        matching_event_2 = FactoryBot.create(
          :event,
          action: "witnessed",
        )

        matching_event_3 = FactoryBot.create(
          :event,
          action: "seen",
        )

        result = Eventful::Event.by_action("witnessed", "seen")

        assert_includes(result, matching_event_1)
        assert_includes(result, matching_event_2)
        assert_includes(result, matching_event_3)
      end
    end

    describe ".by_association" do
      it "matches by integer ID" do
        matching_event = FactoryBot.create(
          :event,
          associations: {
            wombat_id: 7,
          },
        )

        FactoryBot.create(
          :event,
          associations: {
            wombat_id: 18,
          },
        )

        result = Eventful::Event.by_association(:wombat_id, 7)

        assert_equal([matching_event], result)
      end

      it "matches by UUID" do
        match_id = SecureRandom.uuid
        matching_event = FactoryBot.create(
          :event,
          associations: {
            wombat_id: match_id,
          },
        )

        FactoryBot.create(
          :event,
          associations: {
            wombat_id: SecureRandom.uuid,
          },
        )

        result = Eventful::Event.by_association(:wombat_id, match_id)

        assert_equal([matching_event], result)
      end
    end

    describe ".by_data" do
      it "queries events by data" do
        matching_event = FactoryBot.create(
          :event,
          data: { "asdf" => "jkl" },
        )

        FactoryBot.create(
          :event,
          data: { "asdf" => "asdf" },
        )
        result = Eventful::Event.by_data("asdf", "jkl")

        assert_equal([matching_event], result)
      end

      it "queries with symbolic keys" do
        matching_event = FactoryBot.create(
          :event,
          data: { "asdf" => "jkl" },
        )

        FactoryBot.create(
          :event,
          data: { "asdf" => "asdf" },
        )

        result = Eventful::Event.by_data(:asdf, "jkl")

        assert_equal([matching_event], result)
      end

      it "can be chained" do
        matching_event = FactoryBot.create(
          :event,
          data: { "asdf" => "jkl", "jkl" => "qwer" },
        )

        FactoryBot.create(
          :event,
          data: { "asdf" => "jkl" },
        )

        result = Eventful::Event.by_data(:asdf, "jkl").by_data(:jkl, "qwer")

        assert_equal([matching_event], result)
      end
    end

    describe "#data" do
      it "serializes as a hash with symbol keys" do
        e = FactoryBot.create(
          :event,
          data: {
            "foo" => "bar",
          },
        )

        assert_includes(e.data.keys, :foo)
      end

      it "defaults to empty" do
        e = Event.new
        assert_equal(e.data, {})
      end
    end

    describe "#associations" do
      it "serializes as a hash with symbol keys" do
        e = FactoryBot.create(
          :event,
          associations: {
            "wombat_id" => 3,
          },
        )

        assert_includes(e.associations.keys, :wombat_id)
      end

      it "defaults to empty" do
        e = Event.new
        assert_equal(e.associations, {})
      end
    end

    describe "#root_id" do
      it "defaults to nil" do
        e = Event.new
        assert_nil(e.root_id)

        e.valid?
        assert(e.errors[:root_id].empty?)
      end
    end

    describe "#root?" do
      it "is true with no root id" do
        event = FactoryBot.build(
          :event,
          root: nil,
        )

        assert(event.root?)
      end

      it "is false with a root" do
        event = FactoryBot.build(
          :event,
          root: FactoryBot.create(:event),
        )

        refute(event.root?)
      end
    end

    describe "#root" do
      it "returns nil if root event" do
        event = FactoryBot.build(
          :event,
          root: nil,
        )

        assert_nil(event.root)
      end

      it "returns root if one exists" do
        root_event = FactoryBot.create(:event)

        event = FactoryBot.build(
          :event,
          root: root_event,
        )

        assert_equal(root_event, event.root)
      end
    end

    describe "#calculated_root" do
      it "is self with no root id" do
        event = FactoryBot.build(
          :event,
          root: nil,
        )

        assert_equal(event, event.calculated_root)
      end

      it "is some other event with a root" do
        root_event = FactoryBot.create(:event)

        event = FactoryBot.build(
          :event,
          root: root_event,
        )

        assert_equal(root_event, event.calculated_root)
      end
    end

    describe "#progeny" do
      it "fetches all children of a root" do
        root_event = FactoryBot.create(:event)
        progeny = FactoryBot.create(:event, root: root_event)

        assert_includes(root_event.progeny, progeny)
      end

      it "returns an empty array if no progeny exist" do
        event = FactoryBot.create(:event)
        assert(event.progeny.empty?)
      end
    end

    describe "#parent" do
      it "fetches a parent if one exists" do
        parent_event = FactoryBot.create(:event)
        child = FactoryBot.build(:event, parent: parent_event)

        assert_equal(parent_event, child.parent)
      end

      it "returns nil if no parent exists" do
        event = FactoryBot.build(:event)

        assert_nil(event.parent)
      end
    end

    describe "#children" do
      it "returns all children if any exist" do
        parent_event = FactoryBot.create(:event)
        child = FactoryBot.create(:event, parent: parent_event)

        assert_equal([child], parent_event.children)
      end

      it "returns an empty collection if none exist" do
        event = FactoryBot.create(:event)

        assert(event.children.empty?)
      end
    end

    describe "#occurred_at" do
      it "is required" do
        e = Event.new
        refute(e.valid?)
        assert_includes(e.errors[:occurred_at], "can't be blank")
      end
    end

    describe "#description" do
      it "is required" do
        e = Event.new(description: "")
        refute(e.valid?)
        assert_includes(e.errors[:description], "can't be blank")
      end
    end

    describe "#resource" do
      it "is required" do
        e = Event.new(resource: "")
        refute(e.valid?)
        assert_includes(e.errors[:resource], "can't be blank")
      end
    end

    describe "#action" do
      it "is required" do
        e = Event.new(action: "")
        refute(e.valid?)
        assert_includes(e.errors[:action], "can't be blank")
      end
    end
  end
end
