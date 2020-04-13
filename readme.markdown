# Eventful

Eventful creates 1 or more events, typically in response to stateful user
action, logging user activity. This lets us see a timeline of (tracked) activity
in our site.

Eventful is free to use, and 100% unsupported except at my own leisure.

## Usage

An `Eventful::Event` has the following fields:

+ `resource` - this is the kind of domain object we're working with
+ `action` - this is what we did to it
+ `data` - here's an arbitrary JSON (hash) payload
+ `associations` - Any associations that might exist
+ `occurred_at` - DateTime - when did this happen?
+ `description` - Human-readable description

An example:

```ruby
e = Eventful::Event.new(
  resource: "wombat",
  action: "created",
  data: {
    some: "data",
  },
  associations: {
    wombat_id: 7,
    user_id: 23,
  },
  occurred_at: 1.day.ago,
  description: "Wombat created by Andrew Ek",
)
```

We rarely want to make events directly. It's much easier to use the Event
constructor:

```ruby
Eventful.construct_event(
  resource: "wombat",
  action: "created",
  data: {
    some: "data",
  },
  associations: [my_wombat_record, my_user_record],
  occurred_at: 1.day.ago,
  description: "Wombat created by Andrew Ek",
)
```

So we can write events. We can also query them:

```ruby

Eventful::Event.by_resource("wombat")
#=> Events with a resource of "wombat"


Eventful::Event.by_resource("wombat", "echidna")
#=> All Events with a resource of either "wombat" or "echidna")

Eventful::Event.by_action("created")
#=> Events with an action of "created"

Eventful::Event.by_action("created", "updated")
#=> Events with an action of "created" or "updated"

Eventful::Events.by_data(:some_key, "some value")
#=> Events where data includes a top level :some_key and a value of "some value"

Eventful::Events.by_association(:wombat_id, 7)
#=> Events for Wombat with ID 7
```

These queries are chainable:

```ruby
Eventful::Events.by_resource("wombat").by_action("created")
```

We also have can add some nice helper methods available (on demand) through
`Eventful::Associable`. Typically you'll include this per-model, rather than for
everything.

```ruby
class Wombat < ApplicationRecord
  include Eventful::Associable
end
```

Assuming the above setup, we can do the following:

```ruby
Wombat.events
#=> All events with a resource of "wombat"

w = Wombat.find(7)
w.events
#=> All events with an association to this particular Wombat record
```

These queries are also chainable:

```ruby
Wombat.events.by_action("created")
#=> All Wombat-Created events
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eventful', git: "https://github.com/andrewek/eventful.git"
```

And then execute:

```bash
$ bundle
```

You'll still need to run migrations to have access to the events table:

```bash
$ rails eventful:install:migrations
```

Then run:

```bash
$ rails db:migrate
```

You can test this in the Rails console:

```ruby
Eventful::Event.all
#=> []
```

From there, it should be a simple matter of adding `include
Eventful::Associable` to your models, and otherwise working with the exposed
public API.

You can add functionality by monkey-patching any of a number of modules.

## Running Tests

You can run all tests with `$ bin/rails test`

## Contributing

We welcome pull requests. This is a free library, so feature requests will be
prioritized as I see fit and tackled when I see fit.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
