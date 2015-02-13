require "gds_api/test_helpers/publishing_api"

module PublishingAPIHelpers
  include GdsApi::TestHelpers::PublishingApi
  def stub_publishing_api
    stub_default_publishing_api_put
  end

  def reset_remote_requests
    WebMock::RequestRegistry.instance.reset!
  end
end

World(PublishingAPIHelpers)
