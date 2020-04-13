require "eventful/engine"

module Eventful
  def self.construct_event(resource:, action:, data: {}, associations: [], description:, occurred_at: nil, parent_event: nil)
    occurred_at ||= DateTime.now

    Event.create(
      resource: resource,
      action: action,
      description: description,
      occurred_at: occurred_at,
      parent: parent_event,
      root: parent_event&.root,
      associations: mapped_associations(associations),
      data: data,
    )
  end

  def self.mapped_associations(associations)
    [associations].flatten.reduce({}) do |acc, assoc|
      acc.tap do
        key_name = "#{assoc.class.to_s.underscore}_id"
        id = assoc.id
        acc[key_name] = id
      end
    end
  end
end
