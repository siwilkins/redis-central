require File.expand_path('../../spec_helper', __FILE__)

class DummyModel
  include Redis::Central
end

describe "a class including Redis::Central" do

  it "should delegate calls to redis to Redis::Central" do
    redis = mock
    Redis::Central.expects(:redis).returns redis
    DummyModel.redis.must_equal redis
  end

end

describe "an instance of a class including Redis::Central" do

  it "should delegate calls to redis to Redis::Central" do
    redis = mock
    Redis::Central.expects(:redis).returns redis
    DummyModel.new.redis.must_equal redis
  end

end

def test_option(option, value)
  Redis::Central.send("#{option}=", value)
  Redis.expects(:new).with({option => value})
  Redis::Central.redis
end

describe Redis::Central do

  describe "with options" do

    before do
      Redis::Central.send(:reset!)
    end

    it "should pass scheme to Redis.new when set" do
      test_option(:scheme, 'tcp')
    end

    it "should pass host to Redis.new when set" do
      test_option(:host, 'localhost')
    end

    it "should pass port to Redis.new when set" do
      test_option(:port, 1234)
    end

    it "should pass path to Redis.new when set" do
      test_option(:path, '/path/to/redis')
    end

    it "should pass timeout to Redis.new when set" do
      test_option(:timeout, 10.0)
    end

    it "should pass password to Redis.new when set" do
      test_option(:password, 'pa55w0rd')
    end

    it "should pass db to Redis.new when set" do
      test_option(:db, 1)
    end

  end

  describe "when namespaced" do

    before do
      Redis::Central.send(:reset!)
      Redis::Central.namespace = 'my:app'
    end

    it "should return a Redis::Namespace on call to redis" do
      Redis::Central.redis.must_be_instance_of Redis::Namespace
    end

    it "should cache the instance" do
      redis = mock
      Redis::Namespace.expects(:new).once.returns redis
      [Redis::Central.redis, Redis::Central.redis].must_equal [redis, redis]
    end
  end

  describe "when not namespaced" do

    before do
      Redis::Central.send(:reset!)
    end

    it "should return a Redis on call to redis" do
      Redis::Central.redis.must_be_instance_of Redis
    end

    it "should cache the instance" do
      redis = mock
      Redis.expects(:new).once.returns redis
      [Redis::Central.redis, Redis::Central.redis].must_equal [redis, redis]
    end

  end

end
