require "test_helper"

class ChampionshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get championships_create_url
    assert_response :success
  end

  test "should get show" do
    get championships_show_url
    assert_response :success
  end
end
