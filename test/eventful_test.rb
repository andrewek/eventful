# frozen_string_literal: true

require "test_helper"

class Eventful::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Eventful
  end
end
