# frozen_string_literal: true

module Eventful
  # Parent/Children relationships involve direct lineage. An event shares a root
  # with its parent, but there may be other events in between. Similarly, an
  # event has direct children, but we do not (at this time) care about children
  # further down the line.
  module Parentable
    extend ActiveSupport::Concern

    included do
      belongs_to :parent, class_name: "Eventful::Event", optional: true
      has_many :children, class_name: "Eventful::Event", foreign_key: :parent_id
    end
  end
end
