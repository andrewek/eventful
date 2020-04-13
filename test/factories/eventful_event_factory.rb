# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: Eventful::Event do
    occurred_at { DateTime.now }
    resource { "wombat" }
    action { "created" }
    description { "wombat created" }
  end
end
