# CloseableQueue

Wrapper around Queue and SizedQueue adding a `#close` method.

Closed queues allow `#pop` until the queue is drained, then forever return nil
or raise StopIteration.  Pushes to a closed queue also raise an exception.

Ruby 2.3 is expected to support a native `#close` method which works similarly:

  https://bugs.ruby-lang.org/issues/10600

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'closeable_queue'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install closeable_queue

## Usage

```ruby
queue = CloseableQueue.new
queue.push(an_object) # => queue
queue.pop             # => an_object
queue.close
queue.pop             # => nil
queue.close(true)
queue.pop             # => raises CloseableQueue::ClosedQueue (is_a? StopIteration)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freaky/closeable_queue

