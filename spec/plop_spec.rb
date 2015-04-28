require 'spec_helper'
require 'redis'

describe Plop do
  it 'has a version number' do
    expect(Plop::VERSION).not_to be nil
  end

  context "queue" do
    before { queue.clear }
    let(:message) { "Hi there" }
    let(:queue) { Plop::Queue.new(redis) }
    let(:redis) { Redis.new(host: '172.16.48.100', port: 6380) }
    it "should queue and work" do
      queue << message
      expect(queue.messages.first).to eql(message)
    end
  end
end
