require File.dirname(__FILE__) + '/../test_helper'
require "rack/mock"
class MiddlewareTest < Test::Unit::TestCase

  def setup
    @app = Rack::Builder.new do
      use Jammit::Middleware
      run lambda { |env|
        [200, {'Content-Type' => 'text/plain'}, ["Hello World"]]
      }
    end
  end

  def test_normal_requests
    response = Rack::MockRequest.new(@app).get('/')
    assert_equal "Hello World", response.body
  end

  def test_package_with_jst
    @response = Rack::MockRequest.new(@app).get('/assets/jst_test.jst')
    assert @response.headers['Content-Type'] =~ /application\/javascript/
    assert @response.body == File.read("#{ASSET_ROOT}/fixtures/jammed/jst_test.js")
  end

  def test_package_with_jst_mixed
    @response = Rack::MockRequest.new(@app).get('/assets/js_test_with_templates.jst')
    assert @response.headers['Content-Type'] =~ /application\/javascript/
    assert @response.body == File.read("#{ASSET_ROOT}/fixtures/jammed/jst_test.js")
  end


  def test_package_not_found
    @response = Rack::MockRequest.new(@app).get('/assets/no_assets_here.jst')
    assert @response.headers['Content-Type'] =~ /text\/plain/
    assert @response.body == "Not found"
  end
end