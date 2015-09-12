
require 'thread'
require 'concurrent'
require 'closeable_queue/version'

# A wrapper around +Queue+ to provide support for `#close`.
#
# Once closed, threads waiting on dequeue will drain the queue and then receive
# nil on future dequeues. If close(true) is used, pop from an empty closed queue
# or attempts to push raise +ClosedQueue+, a subclass of +StopIteration+.
#
#  Example usage:
#
#   queue = ClosableQueue.new
#   consumer = Thread.new { while number = queue.pop ; puts number ; end }
#   5.times {|x| queue.push(x) }
#   queue.close
#   consumer.join
#
# `#close` is thread-safe and can be called safely multiple times.
#
# This is anticipated to be obsolete by Ruby 2.3 with Queue#close.
#
class CloseableQueue
  class ClosedQueueError < ThreadError
  end

  class ClosedQueue < StopIteration
  end

  # Set up a new queue.  +limit+ will use a SizedQueue, default unbounded Queue.
  def initialize(limit = nil)
    @mutex           = Mutex.new
    @waiting         = Set.new
    @num_waiting     = Concurrent::AtomicFixnum.new
    @closed          = Concurrent::AtomicBoolean.new
    @raise_exception = Concurrent::AtomicBoolean.new(false)

    if limit
      @queue = SizedQueue.new(Integer(limit))
    else
      @queue = Queue.new
    end
  end

  def inspect
    "<#{name} size=#{length} closed=#{closed?} waiting=#{num_waiting}>"
  end

  # Take the first element off the queue.
  #
  # If the queue is empty and closed?, return nil, or optionally raise
  # ClosedQueue (a subclass of StopIteration)
  def pop
    @queue.pop(true)
  rescue ThreadError
    if closed?
      raise ClosedQueue if @raise_exception.true?
      return nil
    else
      sleep
      retry
    end
  end

  [:deq, :shift].each { |name| alias_method name, :pop }

  # Add an item to the queue and wakeup any sleeping consumers.
  #
  # If the queue is closed, raises +ClosedQueueError+.
  def push(item)
    fail ClosedQueueError if closed?

    @queue.push(item)
    wakeup
    self
  end

  [:enq, :<<].each { |name| alias_method name, :push }

  # Get an atomic snapshot if the number of threads waiting on the queue.
  def num_waiting
    @num_waiting.value
  end

  # Get the number of items remaining on the queue
  def length
    @queue.length
  end

  # Return true if the queue is empty
  def empty?
    @queue.empty?
  end

  # Return true if the queue has been closed
  def closed?
    @closed.true?
  end

  # Close the queue if it hasn't been already.  Wake up waiting threads if any.
  def close(raise_exception = false)
    @raise_exception.make_true if raise_exception
    @mutex.synchronize { @waiting.each(&:wakeup) } if @closed.make_true
    self
  end

  private

  def sleep
    @mutex.synchronize do
      @waiting << Thread.current
      @num_waiting.increment
      @mutex.sleep
      @waiting.delete(Thread.current)
      @num_waiting.decrement
    end
  end

  def wakeup
    return if @num_waiting.value.zero?

    @mutex.synchronize do
      @waiting.first.wakeup if @waiting.any?
    end
  end
end

ClosableQueue = CloseableQueue
