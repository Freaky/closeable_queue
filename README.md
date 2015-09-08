# CloseableQueue

Wrapper around Queue and SizedQueue adding a `#close` method.

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

    queue = CloseableQueue.new
    queue.push(an_object)
    queue.pop # => an_object
    queue.close
    queue.pop # => nil
    queue.close(true)
    queue.pop # => CloseableQueue::ClosedQueue (is_a? StopIteration)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/closeable_queue

