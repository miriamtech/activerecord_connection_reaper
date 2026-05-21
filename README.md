# Retire old database connections just like Rails v8.1

Rails v8.1 introduced [some new options][1] for managing database connections,
particularly a few that are useful when running against a pooler, e.g.
PgBouncer, namely:

- **max_age**: number of seconds the pool will allow the connection to exist
  before retiring it at next checkin. (default Float::INFINITY).
- **pool_jitter**: maximum reduction factor to apply to max_age interval
  (default 0.2; range 0.0-1.0).

An existing (but not well-documented) parameter that is also useful in this
scenario is **reaping_frequency**, which determines how often the reaper
thread checks for connections to retire (it defaults to 60 seconds).

However, there's a problem here: **this is only supported as of Rails v8.1**.
Maybe your site isn't running the latest and greatest yet. Maybe... *gasp*
maybe you're still on Ruby v2.5! What is a poor developer to do? Stop whining
and update, obviously. While you're working on that, you can use this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_connection_reaper'
```

Then install it:

    $ bundle install

Once you do that, you can use the `max_age`, `pool_jitter`, and `reaping_frequency`
options in your database configuration almost as if you were actually on Rails v8.1.
Note that this gem is purposefully not compatible with Rails v8.1, to make sure you
remember to remove it when you ARE finally able to update.

[1]: https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/ConnectionPool.html#class-ActiveRecord::ConnectionAdapters::ConnectionPool-label-Options
