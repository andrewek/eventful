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
require 'test_helper'

module Eventful
  class EventTest < ActiveSupport::TestCase
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
          root: nil
        )

        assert(event.root?)
      end

      it "is false with a root" do
        event = FactoryBot.build(
          :event,
          root: FactoryBot.create(:event)
        )

        refute(event.root?)
      end
    end

    describe "#calculated_root" do
      it "is self with no root id" do
        event = FactoryBot.build(
          :event,
          root: nil
        )

        assert_equal(event, event.calculated_root)
      end

      it "is some other event with a root" do
        root_event = FactoryBot.create(:event)

        event = FactoryBot.build(
          :event,
          root: root_event
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
