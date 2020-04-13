# frozen_string_literal: true

module Eventful
  # Base application record
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
