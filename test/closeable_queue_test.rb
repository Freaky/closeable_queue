require 'test_helper'

class CloseableQueueTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CloseableQueue::VERSION
  end

  def closed_queue(items: 0, exception: false)
  	CloseableQueue.new.tap do |queue|
  		items.times { queue.push(:test) }
			queue.close(exception)
		end
  end

  def test_close
  	queue = closed_queue(items: 1)

		assert_equal(queue.pop, :test)
		assert_nil(queue.pop)
		assert_raises(CloseableQueue::ClosedQueueError) { queue.push(:test) }
  end

	def test_close_true
  	queue = closed_queue(items: 1, exception: true)

		assert_equal(queue.pop, :test)
		assert_raises(CloseableQueue::ClosedQueueError) { queue.push(:test) }
		assert_raises(StopIteration) { queue.pop }
	end
end
