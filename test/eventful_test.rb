# frozen_string_literal: true

require "test_helper"

class Eventful::Test < ActiveSupport::TestCase
  extend Minitest::Spec::DSL

  test "truth" do
    assert_kind_of Module, Eventful
  end

  describe ".construct_event" do
    it "constructs with good data" do
      occurred_at = 1.day.ago
      result = Eventful.construct_event(
        resource: "wombat",
        action: "fed",
        description: "Wombat fed",
        occurred_at: occurred_at,
      )

      assert(result.persisted?)
      assert_equal(result.resource, "wombat")
      assert_equal(result.action, "fed")
      assert_equal(result.occurred_at, occurred_at)
      assert_equal(result.description, "Wombat fed")
      assert(result.data.empty?)
      assert(result.associations.empty?)
    end

    it "constructs without an occurred_at" do
      result = Eventful.construct_event(
        resource: "wombat",
        action: "fed",
        description: "Wombat fed",
      )

      assert(result.persisted?)
      assert(result.occurred_at)
    end

    it "passes data" do
      result = Eventful.construct_event(
        resource: "wombat",
        action: "fed",
        description: "Wombat fed",
        data: { foo: "bar" },
      )

      assert(result.persisted?)
      result.reload

      assert(result.data[:foo] = "bar")
    end

    it "transforms associations" do
      associations = [
        Wallaby.new(3),
        Emu.new(4),
        Blah::Capybara.new(5),
      ]

      result = Eventful.construct_event(
        resource: "wombat",
        action: "fed",
        description: "Wombat fed",
        associations: associations,
      )

      assert(result.persisted?)

      associations = result.associations

      assert_equal(3, associations[:wallaby_id])
      assert_equal(4, associations[:emu_id])
      assert_equal(5, associations[:"blah/capybara_id"])
    end

    it "sets a parent appropriately" do
      root = FactoryBot.create(:event)
      parent = FactoryBot.create(:event, parent: root, root: root)

      result = Eventful.construct_event(
        resource: "wombat",
        action: "fed",
        description: "wombat fed",
        parent_event: parent,
      )

      assert result.persisted?

      assert_equal parent, result.parent
      assert_equal root, result.calculated_root
    end

    it "sets a root appropriately" do
    end

    it "returns an invalid record" do
      result = Eventful.construct_event(
        resource: "",
        action: "fed",
        description: "Wombat fed",
      )

      refute result.valid?
      refute result.persisted?
    end
  end
end

Wallaby = Struct.new(:id)
Emu = Struct.new(:id)
module Blah
  Capybara = Struct.new(:id)
end
